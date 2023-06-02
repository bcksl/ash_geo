[
  import_deps: [
    :ash,
    :ash_postgres
  ],
  subdirectories: ["priv/*/migrations"],
  plugins: [Spark.Formatter],
  inputs: [
    "{mix,.formatter}.exs",
    "*.{heex,ex,exs}",
    "{config,lib,test}/**/*.{heex,ex,exs}",
    "priv/*/seeds.exs"
  ]
]
