# Emojitracker REST API :dizzy:

This is the main API endpoint for the Emojitracker REST API.

_(Note: in active development! You may wish to wait for a tagged `v1.0` release
before assuming everything is stable.)_


[![Travis Build Status](https://img.shields.io/travis/emojitracker/emojitrack-rest-api.svg?style=flat-square)](https://travis-ci.org/emojitracker/emojitrack-rest-api)
[![Docker Build Status](https://img.shields.io/docker/build/emojitracker/rest-api.svg?style=flat-square)](https://hub.docker.com/r/emojitracker/rest-api/)

## REST API Specifications

### When to use the REST API

In general, use the REST API to build an initial snapshot state for a page (or
get a one-time use data grab), but then use the [Streaming API][stream-api] to
keep it up to date.

Do not repeatedly poll the REST API.  It is intentionally aggressively cached in
such a way to discourage this, in that the scores will only update at a lower
rate (a few times per minute), meaning you _have_ to use the Streaming API to
get fast realtime data updates.

:rotating_light:
**IN OTHER WORDS, IF YOU ARE POLLING FREQUENTLY FOR UPDATES, YOU ARE DOING
SOMETHING WRONG AND YOU ARE A BAD PERSON.**
:rotating_light:

(Note that this is a design decision, not a server performance issue.)

[stream-api]: https://github.com/emojitracker/emojitrack-streamer-spec

### REST API Endpoints

Production endpoint is: `https://api.emojitracker.com`. All REST endpoints honor
`Accept-Encoding: gzip`. The Emojitracker REST API is lightly versioned
(currently `v1`), and efforts will be made to prevent major breaking changes
without a version change.

#### `GET /v1/rankings`

Returns an array of every emoji in ranked order with scores.

```json
[
  {
    "char": "😂",
    "id": "1F602",
    "name": "FACE WITH TEARS OF JOY",
    "score": 2115292875
  },
  {
    "char": "❤️",
    "id": "2764",
    "name": "HEAVY BLACK HEART",
    "score": 1003931618
  },
  {
    "char": "♻️",
    "id": "267B",
    "name": "BLACK UNIVERSAL RECYCLING SYMBOL",
    "score": 903324343
  },
  /*...snip...*/
  {
    "char": "🚡",
    "id": "1F6A1",
    "name": "AERIAL TRAMWAY",
    "score": 126832
  }
]
```

[Sample response](https://api.emojitracker.com/v1/rankings)



#### `GET /v1/details/:id`

Returns the details of a particular emoji, including a small number of the
most recent [ensmallened](#) tweets.

```json
{
  "char": "🚀",
  "name": "ROCKET",
  "id": "1F680",
  "score": 14796152,
  "popularity_rank": 195,
  "details": {
    "variations": [],
    "short_name": "rocket",
    "short_names": [
      "rocket"
    ],
    "text": null
  },
  "recent_tweets": [
    /*...snip...*/
    {
      "id": "1016150995573895168",
      "text": "Let’s do Launch 🚀 spectacular Pre-dawn Launch from my home base Vandenberg AFB https://t.co/FR0UBanW4o",
      "screen_name": "do_launch",
      "name": "Lets do Launch",
      "links": [
        {
          "url": "https://t.co/FR0UBanW4o",
          "display_url": "spacearchive.info",
          "expanded_url": "http://www.spacearchive.info/",
          "indices": [79, 102]
        }
      ],
      "profile_image_url": "http://pbs.twimg.com/profile_images/1004223593033580544/jYKWIYr9_normal.jpg",
      "created_at": "2018-07-09T02:44:11+00:00"
    }
  ]
}
```

[Sample response](https://api.emojitracker.com/v1/details/2665)

#### `GET /v1/status`

Returns the status of the API server, for healthcheck monitoring.

When healthy, the response will be JSON `{"ok": true}` with a HTTP response code of 200.
If the server can respond while unhealthy, the response will be `{"error": $REASON}` with a
non-200 HTTP response code.

```json
{"ok":true}
```

[Sample response](https://api.emojitracker.com/v1/status)

_...more docs to come._

---

### Development Setup

...Needs to be updated.
