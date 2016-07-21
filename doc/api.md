#1. User Api
--------

###Signin

**URL:** /api/session

**Method: POST**

**Param request:**

  * `session[email]`, type: string, presence: true
  * `session[password]`, type: string, presence: true

**Request example:**

  * `POST: {"user": {"email": "tran.tien.thanh@framgia.com", "password": "12345678"}}`

**Response:** (Return json with user's information if success else return json with error message)

  * `{"user": {"id": 6, "name": "Tran Tien Thanh", "email":"tran.tien.thanh@framgia.com", "avatar": null, "chatwork_id": null, "token": null, "uid": null, "provider": null, "expires_at": null, "refresh_token": null, "email_require": false, "created_at": "2016-07-15T11:05:11.000Z", "updated_at": "2016-07-21T02:06:59.809Z", "auth_token": "_FTuFJ_88PCTM4Bxb-mL"}}`

  * `{"message": "Invalid email or password"}`

###Sign out
  Comming soon

#2. Event Api
---------

###List Event

  Comming soon

###Show Detail Event
**URL:** /api/events/1.json

**METHOD: GET**

**Param Request:**

  * `authentication`, type: string, presence: true

**Response:**

  * `{id: 1, title: "Framgia CRB", description: "", status: null, color: null, all_day: false, repeat_type: "daily", repeat_every: 1, user_id: 6, calendar_id: 6, start_date: "2016-07-21T09:00:00.000Z", finish_date: "2016-07-21T11:00:00.000Z", start_repeat: "2016-07-21T00:00:00.000Z", end_repeat: "2016-07-26T00:00:00.000Z", exception_time: null, exception_type: null, old_exception_type: null, parent_id: null, place_id: null, chatwork_room_id: null, task_content: null, message_content: null, google_event_id: null, google_calendar_id: null, created_at: "2016-07-21T02:28:37.000Z", updated_at: "2016-07-21T02:28:37.000Z", deleted_at: null, attendees: [{id: 2, email: "nguyen.minh.duc@framgia.com", user_id: 7, event_id: 1, created_at: "2016-07-21T02:28:37.000Z", updated_at: "2016-07-21T02:28:37.000Z"}], users: [{id: 7, name: "Nguyen Minh Duc", email: "nguyen.minh.duc@framgia.com", avatar: null, chatwork_id: null, google_calendar_id: "82poim9ul05t12pg4cc0u0hnvo@group.calendar.google.com", token: null, uid: null, provider: null, expires_at: null, refresh_token: null, email_require: false, created_at: "2016-07-15T11:05:12.000Z", updated_at: "2016-07-15T11:05:12.000Z", auth_token: "GABzxD_jfNHL-MiC7-a6"}], repeat_ons: [ ], days_of_weeks: [ ], event_exceptions: [ ], notification_events: [{id: 2, event_id: 1, notification_id: 1, created_at: "2016-07-21T02:28:37.000Z", updated_at: "2016-07-21T02:28:37.000Z"}], notifications: [{id: 1, notification_type: "Email", created_at: "2016-07-15T11:05:06.000Z", updated_at: "2016-07-15T11:05:06.000Z"}], calendar: {id: 6, user_id: 6, name: "Tran Tien Thanh", description: null, color_id: 10, status: "no_public", is_default: true, created_at: "2016-07-15T11:05:11.000Z", updated_at: "2016-07-15T11:05:11.000Z"}, owner: { id: 6, name: "Tran Tien Thanh", email: "tran.tien.thanh@framgia.com", avatar: null, chatwork_id: null, google_calendar_id: "82poim9ul05t12pg4cc0u0hnvo@group.calendar.google.com", token: null, uid: null, provider: null, expires_at: null, refresh_token: null, email_require: false, created_at: "2016-07-15T11:05:11.000Z", updated_at: "2016-07-21T02:06:59.000Z", auth_token: "_FTuFJ_88PCTM4Bxb-mL"}, event_parent: null, place: null}`

###Create Event
**URL:** /api/events.json

**METHOD: POST**

**Params Request:**

  * `authentication`, type: string
  * `event[:title]`, type: string, presence: true, length: {maximum: 255}
  * `event[:start_date]`, type: datetime, presence: true
  * `event[:finish_date]`, type: datetime, presence: true

**Request example:**

  * `POST: {"email": {"title": "Framgia CRB", "start_date":"2016-07-21T09:00:00.000Z", "finish_date":"2016-07-21T11:00:00.000Z"}}`

**Response:**

  * `{"id": 50, "title": "Framgia CRB", "description": null, "status": null, "color": null, "all_day": false, "repeat_type": null, "repeat_every": null, "user_id": 6, "calendar_id": null, "start_date": "2016-07-21T09:00:00.000Z", "finish_date": "2016-07-21T11:00:00.000Z", "start_repeat": null, "end_repeat": null, "exception_time": null, "exception_type": null, "old_exception_type": null, "parent_id": null, "place_id": null, "chatwork_room_id": null, "task_content": null, "message_content": null, "google_event_id": null, "google_calendar_id": null, "created_at": "2016-07-21T02:46:42.997Z", "updated_at": "2016-07-21T02:46:42.997Z", "deleted_at": null, "attendees": [], "users": [], "repeat_ons": [], "days_of_weeks": [], "event_exceptions": [], "notification_events": [], "notifications": [] "calendar": null, "owner": {"id": 6, "name": "Tran Tien Thanh", "email": "tran.tien.thanh@framgia.com", "avatar": null, "chatwork_id": null, "google_calendar_id": "82poim9ul05t12pg4cc0u0hnvo@group.calendar.google.com", "token": null, "uid": null, "provider": null, "expires_at": null, "refresh_token": null, "email_require": false, "created_at": "2016-07-15T11:05:11.000Z", "updated_at": "2016-07-21T02:06:59.000Z", "auth_token": "_FTuFJ_88PCTM4Bxb-mL"}, "event_parent": null, "place": null}`

###Update Event
  Comming soon
