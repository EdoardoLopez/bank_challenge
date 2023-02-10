defmodule BankAPIWeb.Resolvers.TransactionResolver do
  alias BankAPI.Methods.TransactionMethods

  def list_transactions(%{id: id}, %{transaction_filter: filter}, _resolution),
    do: {:ok, TransactionMethods.transactions(%{filter: filter})}

  def list_transactions(%{id: id}, _args, _resolution),
    do: {:ok, TransactionMethods.transactions(%{filter: %{account_id: id}})}

  def list_transactions(_parent, %{transaction_filter: filter}, _resolution),
    do: {:ok, TransactionMethods.transactions(%{filter: filter})}

  def list_transactions(_parent, _args, _resolution),
    do: {:ok, TransactionMethods.transactions()}

  def get_transaction(_parent, %{id: id}, _resolution),
    do: TransactionMethods.get_transaction(id)
end
