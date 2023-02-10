defmodule BankAPIWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation
  alias BankAPIWeb.Resolvers.{TransactionResolver, UserResolver}

  object :account do
    field(:id, :id)
    field(:current_balance, :string)
    field(:account_type, :account_type_enum)
    field(:state, :state_enum)
    field(:user, :user) do
      resolve &UserResolver.get_user/3
    end
    field(:transactions, list_of(:transaction)) do
      arg :transaction_filter, :transaction_filter
      resolve &TransactionResolver.list_transactions/3
    end
  end

  input_object :account_filter do
    field(:user_id, :id)
    field(:account_type, :account_type_enum)
    field(:state, :state_enum)
  end

  @desc "account types"
  enum :account_type_enum do
    value :debit
    value :credit
  end
  @desc "account state types"
  enum :state_enum do
    value :active
    value :inactive
  end
end
