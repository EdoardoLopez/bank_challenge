defmodule BankAPIWeb.Schema.TransactionSchema do
  use Absinthe.Schema.Notation
  alias BankAPIWeb.Resolvers.TransactionResolver

  object :transaction_queries do
    @desc "Fetch all transactions from database"
    field :transactions, list_of(:transaction) do
      arg :transaction_filter, :transaction_filter
      resolve &TransactionResolver.list_transactions/3
    end

    @desc "it return an transaction by id from database"
    field :transaction, :transaction do
      arg :id, non_null(:id)
      resolve &TransactionResolver.get_transaction/3
    end
  end

  # object :transaction_mutations do
  # end
end
