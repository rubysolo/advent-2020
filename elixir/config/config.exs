use Mix.Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# configure your AoC session cookie in `secret.exs` like this:
# config :advent_of_code, :session_cookie, "paste-cookie-here"
import_config "secret.exs"
