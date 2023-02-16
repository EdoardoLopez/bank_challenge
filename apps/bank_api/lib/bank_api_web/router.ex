defmodule BankAPIWeb.Router do
  use BankAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankAPIWeb do
    pipe_through :api
  end

  forward "/", Absinthe.Plug,
    schema: BankAPIWeb.Schema
end
