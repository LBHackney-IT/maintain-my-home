# Hackney - Report a Repair

## Configuration

The application is configured using environment variables. On production these
should be set directly on the server. In development these can be managed by
[dotenv](https://github.com/bkeepers/dotenv): create a `.env.local` file in the
root of the application containing environment variable assignments.

The following environment variables are required to run the site:

- `API_ROOT` - the root of the Hackney API which is used by the site

The following environment variables are optional:

### Analytics

- `GOOGLE_ANALYTICS_ID` - The
  [tracking code](https://support.google.com/analytics/answer/1008080#trackingID)
  for a Google Analytics account
- `HOTJAR_ID` - The
  [tracking code](https://docs.hotjar.com/v1.0/docs/hotjar-tracking-code)
  for a Hotjar analytics account
- `HOTJAR_VERSION` - The
  [Hotjar Snippet Version](https://docs.hotjar.com/v1.0/docs/understanding-the-tracking-code)
  i.e. the version of the Hotjar tracking code being used

### Authentication

 - `HTTP_AUTH_USER` / `HTTP_AUTH_PASSWORD` - Set these to protect the site with
   [HTTP Basic Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication)


## TODO:

* Ruby version

* System dependencies

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
