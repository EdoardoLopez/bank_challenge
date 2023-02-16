defmodule BankUIWeb.PageLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias BankUI.GraphQLClient
  alias BankUI.Queries.UserQuery
  import BankUIWeb.Components

  def render(assigns),
    do: BankUIWeb.PageView.render("index.html", assigns)

  def mount(args, session, socket) do
    send(self(), "list_users")
    {:ok, assign(socket, :users, [])}
  end

  def handle_info("list_users", socket) do
    with {:ok, response} <- UserQuery.list_users() |> GraphQLClient.post() do
      {:noreply, assign(socket, :users, response["data"]["users"])}
    end
  end

  def handle_event("save-user", %{"user" => user}, %{assigns: assigns} = socket) do
    with {:ok, user_response} <- UserQuery.create_user() |> GraphQLClient.post(%{user_input: user}),
         user when is_nil(user) <- user_response["errors"] do
      user_response = user_response["data"]["create_user"]
      {
        :noreply,
        assign(socket, :users, [user_response | assigns.users])
        |> push_event("modal-exec", %{to: "#modal-user", attr: "data-hide"})
        |> put_flash(:info, "User #{user_response["name"]} was created successfully.")
        |> push_patch(to: "/")
      }
    else
      errors ->
        {:noreply, put_flash(socket, :error, errors) }
    end
  end

  def handle_params(params, uri, socket) do
    {:noreply, socket}
  end
end
