use Mix.Config

config :logger, backends: []

config :logger, :dev,
  path: "log/dev.log",
  level: :error
