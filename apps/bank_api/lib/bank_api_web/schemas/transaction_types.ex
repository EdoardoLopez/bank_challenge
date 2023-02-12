defmodule BankAPIWeb.Schema.TransactionTypes do
  use Absinthe.Schema.Notation
  alias BankAPIWeb.Resolvers.AccountResolver

  @desc "object values for transaction"
  object :transaction do
    field(:id, :id)
    field(:amount, :integer)
    field(:type, :type_enum)
    field(:status, :status_enum)
    field(:account, :account) do
      resolve &AccountResolver.get_account/3
    end
  end

  @desc "input values for transaction"
  input_object :transaction_input do
    field(:account_id, :id)
    field(:amount, :integer)
    field(:type, :type_enum)
    field(:status, :status_enum)
  end

  @desc "allow filter transaction with filters"
  input_object :transaction_filter do
    @desc "filter transaction by account id"
    field(:account_id, :id)
    @desc "filter by transaction type"
    field(:type, :type_enum)
    @desc "filter by transaction status"
    field(:status, :status_enum)
  end

  @desc "transaction type enum"
  enum :type_enum do
    value :deposit
    value :withdraw
  end

  @desc "transaction status enum"
  enum :status_enum do
    value :idle
    value :pending
    value :success
    value :failure
  end
end
