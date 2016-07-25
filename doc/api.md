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

  * SUCCESS:

    `{"user": {"id": 6, "name": "Tran Tien Thanh", "email":"tran.tien.thanh@framgia.com", "avatar": null, "chatwork_id": null, "token": null, "uid": null, "provider": null, "expires_at": null, "refresh_token": null, "email_require": false, "created_at": "2016-07-15T11:05:11.000Z", "updated_at": "2016-07-21T02:06:59.809Z", "auth_token": "_FTuFJ_88PCTM4Bxb-mL"}}`

  * FAILS:

    `{"message": "Invalid email or password"}`

####Sign out

**URL:** /api/session/id

**Method: DELETE**

**Param request:**

  * `authentication`, type: string, presence: true

**Response:**

  * SUCCESS:

    `{"message":"Sign out success!"}`

  * FAILS:

    `{}`

#2. Event Api
---------

####List Event

**URL:** /api/events

**Method: GET**

**Param request:**

  * `authentication`, type: string, presence: true
  * `calendars`, type: string

**Response:**

  * `{"id":"8R9XUNdeVuJD6Ud5Zq0ShQ","title":"CRB","start_date":"2016-07-18 01:00","finish_date":"2016-07-18 02:30","start_repeat":"2016-07-18","end_repeat":null,"color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":null,"exception_type":null,"event_id":15,"exception_time":null,"editable":true,"persisted":true},{"id":"9ARTvbz7aWtnh4gfoOHmew","title":"Framgia CRB Meeting","start_date":"2016-07-27 01:00","finish_date":"2016-07-27 03:00","start_repeat":"2016-07-27","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false},{"id":"iH4tXyvr2Fv-2R4Sh0T4NA","title":"Framgia CRB Meeting","start_date":"2016-08-03 01:00","finish_date":"2016-08-03 03:00","start_repeat":"2016-08-03","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false},{"id":"LR03maeZyV3_BLAOa_M01A","title":"Framgia CRB Meeting","start_date":"2016-08-10 01:00","finish_date":"2016-08-10 03:00","start_repeat":"2016-08-10","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false},{"id":"CU1K0SPjSwdM_ql1glVnRA","title":"Framgia CRB Meeting","start_date":"2016-08-17 01:00","finish_date":"2016-08-17 03:00","start_repeat":"2016-08-17","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false},{"id":"T2k87i8siLkgysSh7CLDgg","title":"Framgia CRB Meeting","start_date":"2016-07-25 01:00","finish_date":"2016-07-25 03:00","start_repeat":"2016-07-25","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false},{"id":"xj3-c7w_ounOQkyoChhmzQ","title":"Framgia CRB Meeting","start_date":"2016-08-01 01:00","finish_date":"2016-08-01 03:00","start_repeat":"2016-08-01","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false},{"id":"NpMaSezQ8qm7QRhNgXecjw","title":"Framgia CRB Meeting","start_date":"2016-08-08 01:00","finish_date":"2016-08-08 03:00","start_repeat":"2016-08-08","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false},{"id":"RLsKq1_fE3tlVMVL3EL1vw","title":"Framgia CRB Meeting","start_date":"2016-08-15 01:00","finish_date":"2016-08-15 03:00","start_repeat":"2016-08-15","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false},{"id":"dwR21hn26vS0gC-HEeamPQ","title":"Framgia CRB Meeting","start_date":"2016-07-25 01:00","finish_date":"2016-07-25 03:00","start_repeat":"2016-07-25","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false},{"id":"e0Mp1N3suV5bDvwsmSKo-Q","title":"Framgia CRB Meeting","start_date":"2016-08-01 01:00","finish_date":"2016-08-01 03:00","start_repeat":"2016-08-01","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false},{"id":"23wct42ZnM-__XaysG_AQg","title":"Framgia CRB Meeting","start_date":"2016-08-08 01:00","finish_date":"2016-08-08 03:00","start_repeat":"2016-08-08","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false},{"id":"gzBXPUk-4_Th5Fynkik_vA","title":"Framgia CRB Meeting","start_date":"2016-08-15 01:00","finish_date":"2016-08-15 03:00","start_repeat":"2016-08-15","end_repeat":"2016-08-19","color_id":10,"calendar":"Nguyen Quang Duy","all_day":false,"repeat_type":"weekly","exception_type":null,"event_id":4,"exception_time":null,"editable":true,"persisted":false}`


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
  * `event[title]`, type: string, presence: true, length: {maximum: 255}
  * `event[start_date]`, type: datetime, presence: true
  * `event[finish_date]`, type: datetime, presence: true

**Request example:**

  * `POST: {"event": {"title": "Framgia CRB", "start_date":"2016-07-21T09:00:00.000Z", "finish_date":"2016-07-21T11:00:00.000Z"}}`

**Response:**

  * SUCCESS:

    `{"id": 50, "title": "Framgia CRB", "description": null, "status": null, "color": null, "all_day": false, "repeat_type": null, "repeat_every": null, "user_id": 6, "calendar_id": null, "start_date": "2016-07-21T09:00:00.000Z", "finish_date": "2016-07-21T11:00:00.000Z", "start_repeat": null, "end_repeat": null, "exception_time": null, "exception_type": null, "old_exception_type": null, "parent_id": null, "place_id": null, "chatwork_room_id": null, "task_content": null, "message_content": null, "google_event_id": null, "google_calendar_id": null, "created_at": "2016-07-21T02:46:42.997Z", "updated_at": "2016-07-21T02:46:42.997Z", "deleted_at": null, "attendees": [], "users": [], "repeat_ons": [], "days_of_weeks": [], "event_exceptions": [], "notification_events": [], "notifications": [] "calendar": null, "owner": {"id": 6, "name": "Tran Tien Thanh", "email": "tran.tien.thanh@framgia.com", "avatar": null, "chatwork_id": null, "google_calendar_id": "82poim9ul05t12pg4cc0u0hnvo@group.calendar.google.com", "token": null, "uid": null, "provider": null, "expires_at": null, "refresh_token": null, "email_require": false, "created_at": "2016-07-15T11:05:11.000Z", "updated_at": "2016-07-21T02:06:59.000Z", "auth_token": "_FTuFJ_88PCTM4Bxb-mL"}, "event_parent": null, "place": null}`

  * FAILS:

    `{}`

###Update Event

**URL:** /api/events/id

**Method: PATCH**

**Param request:** (3 options: delete only, delete all follow, delete all)

  * `authentication`, type: string, presence: true
  * `event[title]`, type: string, presence: true, length: {maximum: 255}
  * `event[start_date]`, type: datetime, presence: true
  * `event[finish_date]`, type: datetime, presence: true
  * `event[exception_type]`, type: string, option: edit-only/edit-all-follow/edit-all
  * `event[end_repeat]`, type: datetime
  * `persisted`, type: interger
  * `start_time_before_drag`, type:datetime

**Response:**

* SUCCESS:

  `{"message": "Event was updated successfully." {"id": 48, "title": "CRB", "description": null, "status": null, "color": null, "all_day": false, "repeat_type": null, "repeat_every": null, "user_id": 6, "calendar_id": null, "start_date": "2016-07-22T09:00:00.000Z", "finish_date": "2016-07-22T11:00:00.000Z", "start_repeat": null, "end_repeat": null, "exception_time": null, "exception_type": null, "old_exception_type": null, "parent_id": null, "place_id": null, "chatwork_room_id": null, "task_content": null, "message_content": null, "google_event_id": null, "google_calendar_id": null, "created_at": "2016-07-22T02:46:42.997Z", "updated_at": "2016-07-22T02:46:42.997Z", "deleted_at": null, "attendees": [], "users": [], "repeat_ons": [], "days_of_weeks": [], "event_exceptions": [], "notification_events": [], "notifications": [] "calendar": null, "owner": {"id": 4, "name": "Nguyen Quang Duy", "email": "nguyen.quang.duy@framgia.com", "avatar": null, "chatwork_id": null, "google_calendar_id": "36poim9ul05t12pg4cc0u0hnvo@group.calendar.google.com", "token": null, "uid": null, "provider": null, "expires_at": null, "refresh_token": null, "email_require": false, "created_at": "2016-07-17T11:05:11.000Z", "updated_at": "2016-07-22T02:06:59.000Z", "auth_token": "UCdwirxutvkyHUS_b_CL"}, "event_parent": null, "place": null}}`

* FAILS:

  `{}`


###Delete Event

**URL:** /api/events/id

**MEthod: DELETE**

**Param request:** (3 options: delete only, delete all follow, delete all)

  * `authentication`, type: string, presence: true
  * `exception_type`, type: string, options: delete-only/delete-all-follow/delete-all
  * `exception_time`, type: datetime
  * `start_date_before_delete`, type:datetime

**Response**

* SUCCESS:

  `{"message": "Event deleted"}`

* FAILS:

  `{}`

