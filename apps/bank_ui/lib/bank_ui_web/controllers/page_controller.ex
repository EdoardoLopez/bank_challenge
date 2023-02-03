defmodule BankUIWeb.PageController do
  use BankUIWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
