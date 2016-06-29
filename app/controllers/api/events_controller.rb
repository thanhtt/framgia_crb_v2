class Api::EventsController < ApplicationController
  include TimeOverlapForUpdate
  respond_to :json
  before_action only: [:edit, :update, :destroy] do
    load_event
    validate_permission_change_of_calendar @event.calendar
  end

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

    event = Event.new event_params
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
    end
  end

  def destroy
    @event = Event.find_by id: params[:id]
    if delete_all_event?
      event = @event.parent? ? @event : @event.event_parent
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

  def exception_params
    params.permit :title, :all_day, :start_repeat, :end_repeat,
      :start_date, :finish_date, :exception_type, :exception_time, :parent_id
  end

  def load_event
    @event = Event.find_by id: params[:id]
  end

  def destroy_event event
    if event.destroy
      NotificationDesktopService.new(@event, Settings.destroy_all_event).perform
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

      unless @event.all_day?
        dup_event.start_date = start_date_before_delete
        dup_event.finish_date = finish_date_before_delete
      end

      return dup_event.save
    end

    if @event.update_attributes exception_type: exception_type
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
end
