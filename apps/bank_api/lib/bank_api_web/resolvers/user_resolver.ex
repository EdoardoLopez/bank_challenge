defmodule BankAPIWeb.Resolvers.UserResolver do
  @moduledoc """
  Resolver for users
  """
  alias BankAPI.Methods.UserMethods
  alias BankAPI.Utils

  def list_users(_parent, _args, _resolution),
    do: {:ok, UserMethods.users()}

  def get_user(%{user_id: user_id}, _args, _resolution),
    do: UserMethods.get_user(user_id)

  def get_user(_parent, %{id: id}, _resolution),
    do: UserMethods.get_user(id)

  def create_user(_parent, %{user_input: user_input}, _resolution) do
    UserMethods.create_user(user_input)
    |> Utils.handle_upsert_responses()
  end

  def update_user(_parent, %{id: id, user_input: user_input}, _resolution) do
    UserMethods.get_user(id)
    |> case do
      {:ok, user} ->
        update_user(user, user_input)
      {:error, message} ->
        {:error, message}
    end
  end

  defp update_user(user, params) do
    UserMethods.update_user(user, params)
    |> Utils.handle_upsert_responses()
  end
end
