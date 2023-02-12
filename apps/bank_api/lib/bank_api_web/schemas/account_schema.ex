defmodule BankAPIWeb.Schema.AccountSchema do
  use Absinthe.Schema.Notation
  alias BankAPIWeb.Resolvers.AccountResolver

  object :account_queries do
    @desc "Fetch all accounts from database"
    field :accounts, list_of(:account) do
      arg :account_filter, :account_filter
      resolve &AccountResolver.list_accounts/3
    end

    @desc "it return an account by id from database"
    field :account, :account do
      arg :id, non_null(:id)
      resolve &AccountResolver.get_account/3
    end
  end

  object :account_mutations do
    @desc "create an account"
    field :create_account, :account do
      arg :account_input, non_null(:account_input)
      resolve &AccountResolver.create_account/3
    end

    @desc "create an account"
    field :update_account, :account do
      arg :id, non_null(:id)
      arg :account_input, non_null(:account_input)
      resolve &AccountResolver.update_account/3
    end
  end
end
