# BankChallenge

## Requirements

- Elixir 1.13.4
- Erlang 24.1.7
- NodeJS 16.17.0
- PostgreSQL 11.13

> If you use package manager like [asdf](https://asdf-vm.com/) you can use it.

## Initial Install

- Clone this repository
- Set your own enviromnet variables to `.env_variables` and run `source .env_variables` at root project into terminal
- Install Elixir dependencies with `mix deps.get`, create database with `mix ecto.create` and finally migrate databases schemas with `mix ecto.migrate`
- Optionally you can run `mix setup` to make the whole previous steps automatically
- Finally start the project with `mix phx.server`, if you need type into terminal to test stuffs run `iex -S mix phx.server` instead.

Now you can visit [localhost:4000](http://localhost:4000) in your web browser to see the font-end project, too you can make API requests to [localhost:4001](http://localhost:4001)