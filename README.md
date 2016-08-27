# emojitrack-rest-api :dizzy:
emojitrack tracks realtime emoji usage on twitter!

This is but a small part of emojitracker's infrastructure.  For the full stack,
take a look at https://github.com/mroth/emojitracker.

---
## emojitrack-rest-api
This is the main web app for the Emojitracker REST API.

_NOT YET BEING USED IN PRODUCTION -- SEE `emojitrack-web` FOR NOW._

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
