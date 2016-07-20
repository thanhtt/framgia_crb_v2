class Api::EventsController < ApplicationController
  include TimeOverlapForUpdate
  include Authenticable

  skip_before_filter :authenticate_user!, :verify_authenticity_token, only: :create
  respond_to :json
  before_action only: [:edit, :update, :destroy] do
    load_event
    validate_permission_change_of_calendar @event.calendar
  end
  before_action :authenticate_with_token!, only: [:create, :show, :index]

  def index
    if params[:page].present? || params[:calendar_id]
      @data = current_user.events.upcoming_event(params[:calendar_id])
        .page(params[:page]).per Settings.users.upcoming_event
      respond_to do |format|
        format.html {
          render partial: "users/event", locals: {events: @data, user: current_user}
        }
      end
    else
      @events = Event.in_calendars params[:calendars]
      @events = FullcalendarService.new(@events).repeat_data
      render json: @events.map{|event| event.json_data(current_user.id)}
    end
  end

  def create
    event = current_user.events.build event_params
    if event.save
      render json: event
    else
      render json: {errors: event.errors}, status: 422
    end
  end

  def update
    params[:event] = params[:event].merge({
      exception_time: event_params[:start_date],
      start_repeat: event_params[:start_date],
      end_repeat: event_params[:end_repeat].blank? ? @event.end_repeat : (event_params[:end_repeat])
    })

    argv = {
      is_drop: params[:is_drop],
      start_time_before_drag: params[:start_time_before_drag],
      finish_time_before_drag: params[:finish_time_before_drag]
    }

    event = Event.new handle_event_params
    event.parent_id = @event.event_parent.nil? ? @event.id : @event.parent_id
    event.calendar_id = @event.calendar_id

    if overlap_when_update? event
      render json: {
        text: t("events.flashs.not_updated_because_overlap")
      }, status: :bad_request
    else
      exception_service = EventExceptionService.new(handle_event, params, argv)
      exception_service.update_event_exception

      render json: {
        message: t("events.flashs.updated"),
        event: exception_service.new_event.as_json
      }, status: :ok
    end
  end

  def show
    @event = Event.find_by id: params[:id]

    locals = {
      event_id: params[:id],
      start_date: params[:start],
      finish_date: params[:end]
    }.to_json

    respond_to do |format|
      format.html {
        render partial: "events/popup_event",
          locals: {
            user: current_user,
            event: @event,
            title: params[:title],
            start_date: params[:start],
            finish_date: params[:end],
            fdata: Base64.urlsafe_encode64(locals)
          }
      }
      format.json {render json: @event}
    end
  end

  def destroy
    @event = Event.find_by id: params[:id]
    if delete_all_event?
      if @event.exception_type.present?
        event = @event.parent? ? @event : @event.event_parent
      else
        event = @event
      end
      destroy_event event
    else
      destroy_event_repeat
      render json: {message: t("events.flashs.deleted")}
    end
  end

  private
  def event_params
    params.require(:event).permit Event::ATTRIBUTES_PARAMS
  end

  def handle_event_params
    params.require(:event).permit Event::ATTRIBUTES_PARAMS[1..-2]
  end

  def exception_params
    params.permit :title, :all_day, :start_repeat, :end_repeat,
      :start_date, :finish_date, :exception_type, :exception_time, :parent_id
  end

  def load_event
    @event = Event.find_by id: params[:id]
  end

  def destroy_event event
    event_temp = event.dup
    event_temp.attendees = event.attendees
    if event.destroy
      NotificationDesktopService.new(event_temp, Settings.destroy_all_event).perform
      render json: {message: t("events.flashs.deleted")}, status: :ok
    else
      render json: {message: t("events.flashs.not_deleted")}
    end
  end

  def destroy_event_repeat
    exception_type = params[:exception_type]
    exception_time = params[:exception_time]
    start_date_before_delete = params[:start_date_before_delete]
    finish_date_before_delete = params[:finish_date_before_delete]
    if unpersisted_event?
      parent = @event.parent_id.present? ? @event.event_parent : @event
      dup_event = parent.dup
      dup_event.exception_type = exception_type
      dup_event.exception_time = exception_time
      dup_event.parent_id = parent.id
      parent.attendees.each do |attendee|
        dup_event.attendees.new(user_id: attendee.user_id,
          event_id: dup_event.id)
      end
      if @event.all_day?
        dup_event.start_date = exception_time.to_datetime.beginning_of_day
        dup_event.finish_date = exception_time.to_datetime.end_of_day
      else
        dup_event.start_date = start_date_before_delete
        dup_event.finish_date = finish_date_before_delete
      end
      if exception_type == "delete_all_follow"
        event_exception_pre_nearest(parent, exception_time).update(end_repeat: (exception_time.to_date - 1.day))
        NotificationDesktopService.new(dup_event,
          Settings.destroy_all_following_event).perform
      end

      NotificationDesktopService.new(dup_event, Settings.destroy_event).perform
      return dup_event.save
    elsif @event.edit_all_follow? && exception_type == "delete_only"
      @event.update(old_exception_type: Event.exception_types[:edit_all_follow])
    elsif @event.parent? && exception_type == "delete_only"
      @event.update(old_exception_type: Event.exception_types[:edit_all_follow])
    end

    if @event.update_attributes exception_type: exception_type, exception_time: exception_time
      NotificationDesktopService.new(@event, Settings.destroy_event).perform
    end
  end


  def unpersisted_event?
    params[:persisted].to_i == 0
  end

  def handle_event
    return @event if @event.parent_id.blank?
    params[:persisted].to_i == 0 ? @event.event_parent : @event
  end

  def delete_all_event?
    params[:exception_type] ==  "delete_all"
  end

  def event_exception_pre_nearest parent, exception_time
    events = parent.event_exceptions
      .follow_pre_nearest(exception_time).order(start_date: :desc)
    events.size > 0 ? events.first : parent
  end
end
