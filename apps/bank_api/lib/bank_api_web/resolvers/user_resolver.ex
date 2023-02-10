defmodule BankAPIWeb.Resolvers.UserResolver do
  alias BankAPI.Methods.UserMethods

  def list_users(_parent, _args, _resolution),
    do: {:ok, UserMethods.users()}

  def get_user(%{user_id: user_id}, _args, _resolution),
    do: UserMethods.get_user(user_id)

  def get_user(_parent, %{id: id}, _resolution),
    do: UserMethods.get_user(id)
end
