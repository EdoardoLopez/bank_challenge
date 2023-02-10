defmodule BankAPIWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation
  alias BankAPIWeb.Resolvers.AccountResolver

  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
    field(:accounts, list_of(:account)) do
      arg :account_filter, :account_filter
      resolve &AccountResolver.list_accounts/3
    end
  end
end
