defmodule BankUIWeb.UserLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias BankUI.GraphQLClient
  alias BankUI.Queries.{AccountQuery, TransactionQuery, UserQuery}
  import BankUIWeb.Components

  def render(assigns),
    do: BankUIWeb.PageView.render("user_details.html", assigns)

  def mount(%{"id" => id} = args, session, socket) do
    socket =
      assign(socket, %{
        user_id: id,
        user: nil,
        accounts: [],
        transactions: [],
        current_account_id: 0,
      })

    send(self(), "fetch_info")
    {:ok, socket}
  end

  def handle_info("fetch_info", %{assigns: assigns} = socket) do
    with {:ok, user_response} <- fetch_user(assigns.user_id),
         {:ok, accounts_response} <- fetch_accounts(assigns.user_id) do

      accounts = accounts_response["data"]["accounts"]
      current_account = if(Enum.empty?(accounts), do: [], else: Enum.find(accounts, &(&1["state"] == "ACTIVE")))

      socket =
        assign(socket, %{
          user: user_response["data"]["user"],
          accounts: accounts,
          transactions: if(Enum.empty?(current_account), do: [], else: current_account["transactions"]),
          current_account_id: if(Enum.empty?(current_account), do: 0, else: current_account["id"])
        })

      {:noreply, socket}
    end
  end

  def handle_event("save-account", %{"account" => account_params}, %{assigns: assigns} = socket) do
    account_params = Map.put(account_params, "current_balance", String.to_integer(account_params["current_balance"]))
    with {:ok, account_response} <- AccountQuery.create_account() |> GraphQLClient.post(%{account_input: account_params}),
         account when is_nil(account) <- account_response["errors"] do
      account = account_response["data"]["create_account"]
      {
        :noreply,
        assign(socket, %{
          accounts: [account | assigns.accounts],
          current_account_id: account["id"]
        })
        |> push_event("modal-exec", %{to: "#modal-account", attr: "data-hide"})
        |> put_flash(:info, account["account_type"] <> " account was created successfully")
      }
    else
      errors ->
        {:noreply, put_flash(socket, :error, errors)}
    end
  end

  def handle_event("save-transaction", %{"transaction" => transaction_params}, %{assigns: assigns} = socket) do
    transaction_params =
      Map.put(transaction_params, "account_id", assigns.current_account_id)
      |> Map.put("amount", String.to_integer(transaction_params["amount"]))
    with {:ok, transaction_response} <- TransactionQuery.create_transaction() |> GraphQLClient.post(%{transaction_input: transaction_params}),
         transaction when is_nil(transaction) <- transaction_response["errors"] do

      account = Enum.find(assigns.accounts, &(&1["id"] == assigns.current_account_id))
      account_index = Enum.find_index(assigns.accounts, &(&1["id"] == assigns.current_account_id))
      transaction = transaction_response["data"]["create_transaction"]
      accounts_updated =
        List.update_at(assigns.accounts, account_index, fn ac ->
          Map.put(ac, "current_balance", calculate_balance(ac["current_balance"], transaction["amount"], transaction["type"]))
        end)

      {
        :noreply,
        assign(socket, %{
          accounts: accounts_updated,
          transactions: [transaction | assigns.transactions]
        })
        |> push_event("modal-exec", %{to: "#modal-transaction", attr: "data-hide"})
        |> put_flash(:info, transaction["type"] <> " was proccessed successfully")
      }
    else
      errors ->
        {:ok, transaction_response} =
          TransactionQuery.transactions()
          |> GraphQLClient.post(%{transaction_filter: %{account_id: assigns.current_account_id}})

        {
          :noreply,
          assign(socket, :transactions, transaction_response["data"]["transactions"])
          |> put_flash(:error, errors)
        }
    end
  end

  defp calculate_balance(balance, amount, type) when type == "WITHDRAW" do
    balance - amount
  end
  defp calculate_balance(balance, amount, type) when type == "DEPOSIT" do
    balance + amount
  end

  def handle_event("set-current-account", %{"account_id" => account_id}, %{assigns: assigns} = socket) do
    account = Enum.find(assigns.accounts, &(&1["id"] == account_id))

    socket = assign(socket, %{
      current_account_id: account_id,
      transactions: account["transactions"]
    })
    {:noreply, socket}
  end

  def handle_event("home", _params, socket) do
    {:noreply, push_navigate(socket, to: "/")}
  end

  def handle_params(params, uri, socket) do
    {:noreply, socket}
  end

  defp fetch_user(user_id) do
    UserQuery.fetch_user()
    |> GraphQLClient.post(%{id: user_id})
  end

  defp fetch_accounts(user_id) do
    AccountQuery.list_accounts()
    |> GraphQLClient.post(%{account_filter: %{user_id: user_id}})
  end
end
