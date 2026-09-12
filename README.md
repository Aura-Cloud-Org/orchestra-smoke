# orchestra-smoke

A deliberately boring dbt project, used to check that Orchestra itself works.

`dbt build` here seeds two CSVs, builds three models, and runs ten tests. It
should always succeed. When a run of this project fails, the problem is
Orchestra — the clone, the profile, the warehouse connection, artifact
ingestion — not the project.

That is the whole design goal, and it is why some ordinary things are missing:

- **No `packages.yml`.** Package version constraints are resolved from the dbt
  hub at `dbt deps` time, so a project with dependencies can begin failing on a
  commit that never changed. Nothing here to resolve.
- **No `require-dbt-version`.** A runner image upgrade cannot strand it.
- **No sources.** A source expects rows already in the warehouse. Seeds bring
  their own, so this builds against a completely empty database.
- **Plain ANSI SQL.** No adapter-specific functions, so the same project runs on
  Postgres, Snowflake, BigQuery or DuckDB unchanged.

## What it builds

```
customers (seed) ─┐
                  ├─→ stg_customers ─┐
orders (seed) ────┴─→ stg_orders ────┴─→ customer_order_summary
```

Customer 5 has no completed order on purpose: it is what makes the `not_null`
test on `lifetime_value` meaningful, since the aggregate is null without the
`coalesce` and the test catches its removal.
Check run verification, 2026-09-12.
Second push, after the clone fix (NEW-43).
