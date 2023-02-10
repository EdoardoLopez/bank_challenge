defmodule BankAPIWeb.Schema.UserSchema do
  use Absinthe.Schema.Notation
  alias BankAPIWeb.Resolvers.UserResolver

  object :user_queries do
    @desc "Fetch all users from database"
    field :users, list_of(:user) do
      resolve &UserResolver.list_users/3
    end

    @desc "it return an user by id from database"
    field :user, :user do
      arg :id, non_null(:id)
      resolve &UserResolver.get_user/3
    end
  end

  # object :user_mutations do
  # end
end
