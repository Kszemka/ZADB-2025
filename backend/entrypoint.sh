#!/bin/bash
set -e

export SECRET_KEY_BASE=${SECRET_KEY_BASE:-$(bundle exec rails secret)}
bundle exec rails db:drop 2>/dev/null || true
bundle exec rails db:create
bundle exec rails db:schema:load
bundle exec rails db:seed
bundle exec puma \
  --bind "ssl://0.0.0.0:3000?key=config/ssl/server.key&cert=config/ssl/server.crt"
exec bundle exec rails server -b 0.0.0.0 -p 3000
