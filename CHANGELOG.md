### 1.0.0 (NOT YET RELEASED)

- `/v1/` namespaced release of the API.
- Moving production servers to `api.emojitracker.com` endpoint.
- Minor changes to `/details/:id` return structure, omitting many
  ancient fields contained in emoji_data.rb library but not really
  relevant to modern usage.

### 0.x.x

- Unversioned API for internal use, running integrated on frontend
  web server, but kinda unofficially being used by many.
