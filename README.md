# Acme

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Postgres

```sh
docker container rm postgres && docker run --name postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres
```

## Generate

```sh
mix phx.gen.json Accounts Team teams name:string && mix phx.gen.json Accounts Role roles name:string team_id:references:teams && mix phx.gen.json Accounts Permission permissions name:string team_id:references:teams && mix phx.gen.json Accounts Membership memberships user_id:references:users team_id:references:teams && mix phx.gen.json Accounts MembershipRole membership_roles membership_id:references:memberships role_id:references:roles
```
