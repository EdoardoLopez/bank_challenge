defmodule BankAPIWeb.Resolvers.AccountResolver do
  @moduledoc """
  Resolver for accounts
  """
  alias BankAPI.Methods.AccountMethods
  alias BankAPI.Utils

  def list_accounts(%{id: _user_id}, %{account_filter: filter}, _resolution),
    do: {:ok, AccountMethods.accounts(%{filter: filter})}

  def list_accounts(_parent, %{account_filter: filter}, _resolution),
    do: {:ok, AccountMethods.accounts(%{filter: filter})}

  def list_accounts(%{id: user_id}, _args, _resolution),
    do: {:ok, AccountMethods.accounts(%{filter: %{user_id: user_id}})}

  def list_accounts(_parent, _args, _resolution),
    do: {:ok, AccountMethods.accounts()}

  def get_account(%{account_id: account_id}, _args, _resolution),
    do: AccountMethods.get_account(account_id)

  def get_account(_parent, %{id: id}, _resolution),
    do: AccountMethods.get_account(id)

  def create_account(_parent, %{account_input: input}, _resolution) do
    AccountMethods.create_account(input)
    |> Utils.handle_upsert_responses()
  end

  def update_account(_parent, %{id: id, account_input: input}, _resolution) do
    AccountMethods.get_account(id)
    |> case do
      {:ok, account} ->
        update_account(account, input)
      {:error, message} ->
        {:error, message}
    end
  end

  def update_account(account, params) do
    AccountMethods.update_account(account, params)
    |> Utils.handle_upsert_responses()
  end
end
