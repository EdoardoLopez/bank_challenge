defmodule BankAPIWeb.Schema.TransactionTypes do
  use Absinthe.Schema.Notation
  alias BankAPIWeb.Resolvers.AccountResolver

  object :transaction do
    field(:id, :id)
    field(:amount, :integer)
    field(:type, :type_enum)
    field(:status, :status_enum)
    field(:account, :account) do
      resolve &AccountResolver.get_account/3
    end
  end

  input_object :transaction_filter do
    field(:account_id, :id)
    field(:type, :type_enum)
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
