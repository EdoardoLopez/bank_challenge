defmodule BankAPIWeb.Resolvers.AccountResolver do
  alias BankAPI.Methods.AccountMethods

  def list_accounts(%{id: user_id}, %{account_filter: filter}, _resolution),
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
end
