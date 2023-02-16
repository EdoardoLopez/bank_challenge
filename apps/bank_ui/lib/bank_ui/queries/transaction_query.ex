defmodule BankUI.Queries.TransactionQuery do
  @moduledoc """
  Transactions queries with GraphQL format.
  """
  def transactions do
    """
    query($transaction_filter: TransactionFilter) {
      transactions(transactionFilter: $transaction_filter) {
        id
        status
        type
        amount
        inserted_at
        updated_at
      }
    }
    """
  end

  def create_transaction do
    """
    mutation($transaction_input: TransactionInput!) {
      create_transaction(transactionInput: $transaction_input) {
        id
        amount
        status
        type
        inserted_at
        updated_at
      }
    }
    """
  end

  def update_transaction do
    """
    mutation($id: ID!, $transaction_input: TransactionInput!) {
      update_transaction(id: $id, transactionInput: $transaction_input) {
        id
        amount
        status
        type
        inserted_at
        updated_at
      }
    }
    """
  end
end
