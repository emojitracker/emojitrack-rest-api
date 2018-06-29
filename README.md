# emojitrack-rest-api :dizzy:
> Emojitracker tracks realtime emoji usage on Twitter

This is but a small part of emojitracker's infrastructure.  For the full stack,
take a look at https://github.com/mroth/emojitracker.

---
## emojitrack-rest-api
This is the main API endpoint for the Emojitracker REST API.

_NOT YET BEING USED IN PRODUCTION YET — SEE `emojitrack-web` FOR NOW._

[![Docker Build Status](https://img.shields.io/docker/build/emojitracker/rest-api.svg?style=flat-square)](https://hub.docker.com/r/emojitracker/rest-api/)


### Important note on API usage
**Read this first and be sure you understand it:** When attemping to utilize the
realtime nature of Emojitracker, theREST API should only be used to establish
initial data state, for subsequent updates use the Emojitracker Streaming API.

:rotating_light:
**IN OTHER WORDS, IF YOU ARE POLLING INSTEAD FOR UPDATES, YOU ARE DOING
SOMETHING WRONG AND YOU ARE A BAD PERSON.**
:rotating_light:

### API specification
All REST endpoints honor `Accept-Encoding: gzip`.

#### `GET /v1/rankings`
Returns every emoji in ranked order with scores.

[Sample response](https://api.emojitracker.com/v1/rankings)

#### `GET /v1/details/:id`
Returns the details of a particular emoji, including a small number of the
most recent [ensmallened](#) tweets.

[Sample response](https://api.emojitracker.com/v1/details/2665)

#### `GET /v1/status`
Returns the status of the API server, for healthcheck monitoring.

When healthy, the response will be JSON `{"ok": true}` with a HTTP response code of 200.
If the server can respond while unhealthy, the response will be `{"error": $REASON}` with a
non-200 HTTP response code.

[Sample response](https://api.emojitracker.com/v1/status)

_...more docs to come._

---
### Development Setup

...Needs to be updated.
