defmodule BankAPIWeb.Resolvers.TransactionResolver do
  @moduledoc """
  Resolver for transactions
  """
  alias BankAPI.Methods.TransactionMethods
  alias BankAPI.Utils

  def list_transactions(%{id: _id}, %{transaction_filter: filter, order: order}, _resolution),
    do: {:ok, TransactionMethods.transactions(%{filter: filter, order: order})}

  def list_transactions(%{id: id}, %{order: order}, _resolution),
    do: {:ok, TransactionMethods.transactions(%{filter: %{account_id: id}, order: order})}

  def list_transactions(_parent, %{transaction_filter: filter, order: order}, _resolution),
    do: {:ok, TransactionMethods.transactions(%{filter: filter, order: order})}

  def list_transactions(_parent, _args, _resolution),
    do: {:ok, TransactionMethods.transactions()}

  def get_transaction(_parent, %{id: id}, _resolution),
    do: TransactionMethods.get_transaction(id)

  def create_transaction(_parent, %{transaction_input: input}, _resolution) do
    TransactionMethods.create_transaction(input)
    |> case do
      {:ok, transaction} ->
        {:ok, transaction.transaction}
      {:error, _failed_operation, changeset, _changes_so_far} ->
        format_error_changeset(changeset)
      {:error, changeset} ->
        format_error_changeset(changeset)
    end
  end

  def update_transaction(_parent, %{id: id, transaction_input: input}, _resolution) do
    TransactionMethods.get_transaction(id)
    |> case do
      {:ok, transaction} ->
        update_transaction(transaction, input)
      {:error, message} ->
        {:error, message}
    end
  end

  def update_transaction(transaction, params) do
    TransactionMethods.update_transaction(transaction, params)
    |> Utils.handle_upsert_responses()
  end

  defp format_error_changeset(%Ecto.Changeset{} = changeset),
    do: {:error, Utils.transform_errors(changeset)}
  defp format_error_changeset(changeset),
    do: {:error, changeset}
end
