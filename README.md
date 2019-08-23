# Hackney - Report a Repair

## Configuration

The application is configured using environment variables. On production these
should be set directly on the server. In development these can be managed by
[dotenv](https://github.com/bkeepers/dotenv): create a `.env.local` file in the
root of the application containing environment variable assignments.

### Required config

The following environment variables are required to run the site:

- `HACKNEY_API_URL` - the root of the Hackney API which is used by the site
- `ENCRYPTION_SECRET` - secret used to prevent parameter tampering. Generate
  one with e.g. `rake secret`

### Optional config

The app should run successfully without these environment variables:

#### Analytics

- `GOOGLE_ANALYTICS_ID` - The
  [tracking code](https://support.google.com/analytics/answer/1008080#trackingID)
  for a Google Analytics account
- `HOTJAR_ID` - The
  [tracking code](https://docs.hotjar.com/v1.0/docs/hotjar-tracking-code)
  for a Hotjar analytics account
- `HOTJAR_VERSION` - The
  [Hotjar Snippet Version](https://docs.hotjar.com/v1.0/docs/understanding-the-tracking-code)
  i.e. the version of the Hotjar tracking code being used

#### Monitoring

- `ROLLBAR_ACCESS_TOKEN` - The access token for the
  [rollbar](https://rollbar.com) account used to monitor system errors
- `ROLLBAR_ENV` - Defines which environment rollbar errors are logged to. By
  default this is `Rails.env` and doesn't need to be set in development but on
  the staging server this should be set to 'staging'.

#### Authentication

- `HTTP_AUTH_USER` / `HTTP_AUTH_PASSWORD` - Set these to protect the site with
   [HTTP Basic Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication)
- `FLIPPER_AUTH_USER` / `FLIPPER_AUTH_PASSWORD` - As above, but for feature flag UI

#### Miscellaneous

- `RACK_SERVICE_TIMEOUT` - Set this to control the point at which
  `Rack::Timeout` times-out an HTTP request. This is used to ensure that the
  app times out before Heroku automatically kills the connection and displays
  its own, less friendly, error message. Defaults to 15 seconds.
- `APPOINTMENT_LIMIT` - Set this to override the maximum number of appointments
  returned from the `AppointmentFetcher` service. Defaults to 15.
- `ONE_ACCOUNT_URL` - Set this to override the URL that redirects users to One
  Account in the event that Report a Repair is disabled (see feature flagging
  below).

#### Feature flagging

The following feature flags can be used. The first time these are used, they
should be created via the Flipper UI:

- `service_disabled` - Enabling this flag disables the service completely. All
  pages will return a message prompting users to call the Repairs Contact
  Centre. This is to be used when Hackney back-end systems are unavailable.

## TODO:

* Ruby version

* System dependencies

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
