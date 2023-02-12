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

  object :user_mutations do
    @desc "create an user"
    field :create_user, :user do
      arg :user_input, non_null(:user_input)
      resolve &UserResolver.create_user/3
    end

    @desc "update an user"
    field :update_user, :user do
      arg :id, non_null(:id)
      arg :user_input, non_null(:user_input)
      resolve &UserResolver.update_user/3
    end
  end
end
