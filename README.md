# emojitrack-rest-api :dizzy:
emojitracker tracks realtime emoji usage on twitter!

This is but a small part of emojitracker's infrastructure.  For the full stack,
take a look at https://github.com/mroth/emojitracker.

---
## emojitrack-rest-api
This is the main web app for the Emojitracker REST API.

_NOT YET BEING USED IN PRODUCTION YET — SEE `emojitrack-web` FOR NOW._

### API specification
_Read this first and be sure you understand it:_ The REST API should only be
used to establish initial page state, for subsequent updates use the
Emojitracker Streaming API.

**IF YOU ARE POLLING REGULARLY FOR UPDATES, YOU ARE DOING SOMETHING WRONG AND
YOU ARE A BAD PERSON.**

All REST endpoints honor `Accept-Encoding: gzip`.

#### `GET /v1/rankings`
Returns every emoji in ranked order with scores.
[Sample response](http://emojitracker.com/api/rankings)

#### `GET /v1/details/:id`
Returns the details of a particular emoji, including a small number of the
most recent [ensmallened](#) tweets.
[Sample response](http://emojitracker.com/api/details/2665)

#### `GET /v1/status`
Returns the status of the API server, for healthcheck monitoring.

When healthy, the response will be JSON `{"ok": true}` with a HTTP response code of 200.
If the server can respond while unhealthy, the response will be `{"error": $REASON}` with a
non-200 HTTP response code.

...more docs to come.

### Development Setup

#### Local dependencies
1. Make sure you have Ruby 2.3.x installed and `gem install bundler`.
2. Get the repository and basic dependencies going:

    ```
    git clone mroth/emojitrack
    cd emojitrack
    bundle install --without=production
    ```

3. Copy `.env-sample` to `.env` and configure required variables.
4. Make sure you have Redis installed and running.  Depending on what you are
doing, you may need to have the db populated from a emojitrack-feeder instance.
5. Run all processes via `foreman start`.

#### Using Docker Compose (recommended)
1. Make sure you have Docker and Docker Compose installed.
2. Clone this repository.
3. Copy `.env-sample` to `.env` and configure required variables.
4. Run all processes via `docker-compose up`.
