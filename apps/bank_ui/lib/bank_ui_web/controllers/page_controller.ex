defmodule BankUiWeb.PageController do
  use BankUiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
