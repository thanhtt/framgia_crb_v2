class EventsController < ApplicationController
  include TimeOverlapForUpdate
  include CreateNewObject

  load_and_authorize_resource
  skip_before_action :authenticate_user!, only: :show
  before_action :load_calendars, only: [:new, :edit]
  before_action only: [:edit, :update, :destroy] do
    validate_permission_change_of_calendar @event.calendar
  end

  def new
    if params[:fdata]
      hash_params = JSON.parse(Base64.decode64 params[:fdata]) rescue {"event": {}}
      if hash_params["event_id"].present?
        @event = Event.find(hash_params["event_id"]).dup
      elsif hash_params["title"].present?
        @event = Event.new title: hash_params["title"]
      else
        @event = Event.new hash_params["event"]
      end
    end

    Notification.all.each do |notification|
      @event.notification_events.find_or_initialize_by notification: notification
    end

    DaysOfWeek.all.each do |days_of_week|
      @event.repeat_ons.find_or_initialize_by days_of_week: days_of_week
    end
    @repeat_ons = @event.repeat_ons.sort{|a, b| a.days_of_week_id <=> b.days_of_week_id}
  end

  def create
    create_user_when_add_attendee
    create_place_when_add_location

    modify_repeat_params if params[:repeat].nil?
    @event = current_user.events.new event_params

    event_overlap = EventOverlap.new(@event)
    if event_overlap.overlap?
      @time_overlap = load_overlap_time(event_overlap)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      respond_to do |format|
        if @event.save
          ChatworkServices.new(@event).perform
          NotificationDesktopService.new(@event, Settings.create_event).perform

          if @event.repeat_type.present?
            FullcalendarService.new.generate_event_delay @event
          else
            NotificationEmailService.new(@event).perform
          end
          NotificationDesktopJob.new(@event, Settings.start_event).perform

          flash[:success] = t "events.flashs.created"
          format.html {redirect_to root_path}
          format.js {@data = @event.json_data(current_user.id)}
        else
          flash[:error] = t "events.flashs.not_created"
          format.html {redirect_to new_event_path}
          format.js
        end
      end
    end
  end

  def edit
    if params[:fdata]
      hash_params = JSON.parse(Base64.decode64 params[:fdata]) rescue {"event": {}}
      @event.start_date = DateTime.strptime hash_params["start_date"], t("events.datetime")
      if @event.all_day?
        @event.finish_date = @event.start_date.end_of_day
      else
        @event.finish_date = DateTime.strptime hash_params["finish_date"], t("events.datetime")
      end
    end
    Notification.all.each do |notification|
      @event.notification_events.find_or_initialize_by notification: notification
    end

    DaysOfWeek.all.each do |days_of_week|
      @event.repeat_ons.find_or_initialize_by days_of_week: days_of_week
    end
    @repeat_ons = @event.repeat_ons.sort{|a, b| a.days_of_week_id <=> b.days_of_week_id}
  end

  def update
    create_user_when_add_attendee
    create_place_when_add_location

    modify_repeat_params if params[:repeat].nil?
    params[:event] = params[:event].merge({
      exception_time: event_params[:start_date],
      start_repeat: event_params[:start_repeat].nil? ? event_params[:start_date] : event_params[:start_repeat],
      end_repeat: event_params[:end_repeat].nil? ? @event.end_repeat : event_params[:end_repeat].to_date
    })
    event = Event.new handle_event_params
    event.parent_id = @event.parent? ? @event.id : @event.parent_id
    event.calendar_id = @event.calendar_id

    respond_to do |format|
      if @overlap_when_update = overlap_when_update?(event)
        flash[:error] = t "events.flashs.not_updated_because_overlap"
        format.js
      else
        EventExceptionService.new(@event, params, {}).update_event_exception
        flash[:success] = t "events.flashs.updated"
        format.js
      end
    end
  end

  def destroy
    if @event.destroy
      flash[:success] = t "events.flashs.deleted"
    else
      flash[:danger] = t "events.flashs.not_deleted"
    end
    redirect_to root_path
  end

  private
  def event_params
    params.require(:event).permit Event::ATTRIBUTES_PARAMS
  end

  def handle_event_params
    params.require(:event).permit Event::ATTRIBUTES_PARAMS[1..-2]
  end

  def load_calendars
    @calendars = current_user.manage_calendars
  end

  def load_overlap_time event_overlap
    if @event.start_repeat.nil? ||
      (@event.start_repeat.to_date >= event_overlap.time_overlap.to_date)
      return Settings.full_overlap
    else
      time_overlap = (event_overlap.time_overlap - 1.day).to_s
      event_params[:end_repeat] = time_overlap
      return time_overlap
    end
  end

  def modify_repeat_params
    [:repeat_type, :repeat_every, :start_repeat, :end_repeat, :repeat_ons_attributes]
      .each {|attribute| params[:event].delete attribute}
  end
end
