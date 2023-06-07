[
  tools: [
    format: "mix format",
    outdated: "mix hex.outdated",
    deps_audit: "mix deps.audit",
    docs: "mix docs",
    sobelow: "mix sobelow --config",
    migrations: "mix ash_postgres.generate_migrations --check",
    coveralls: "mix coveralls"
  ]
]
