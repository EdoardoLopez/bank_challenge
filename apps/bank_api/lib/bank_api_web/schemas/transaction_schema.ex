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

  object :transaction_mutations do
    @desc "create a transaction"
    field :create_transaction, :transaction do
      arg :transaction_input, non_null(:transaction_input)
      resolve &TransactionResolver.create_transaction/3
    end

    @desc "update a transaction"
    field :update_transaction, :transaction do
      arg :id, non_null(:id)
      arg :transaction_input, non_null(:transaction_input)
      resolve &TransactionResolver.update_transaction/3
    end
  end
end
