defmodule BankAPIWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation
  alias BankAPIWeb.Resolvers.{TransactionResolver, UserResolver}

  @desc "object values for account"
  object :account do
    field(:id, :id)
    field(:current_balance, :integer)
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

  @desc "input values for account"
  input_object :account_input do
    field(:user_id, :id)
    field(:current_balance, :integer)
    field(:account_type, :account_type_enum)
    field(:state, :state_enum)
  end

  @desc "allow filter accounts"
  input_object :account_filter do
    @desc "filter accounts by user id"
    field(:user_id, :id)
    @desc "filter accounts by account type"
    field(:account_type, :account_type_enum)
    @desc "filter accounts by state"
    field(:state, :state_enum)
  end

  @desc "account types enum"
  enum :account_type_enum do
    value :debit
    value :credit
  end

  @desc "account state types enum"
  enum :state_enum do
    value :active
    value :inactive
  end
end
