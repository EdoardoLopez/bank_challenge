defmodule BankUI.Queries.UserQuery do
  @moduledoc """
  User queries with GraphQL format.
  """
  def list_users do
    """
    query {
      users {
        id
        name
        email
      }
    }
    """
  end

  def fetch_user do
    """
    query($id: ID!) {
      user(id: $id) {
        id
        name
        email
      }
    }
    """
  end

  def create_user do
    """
    mutation($user_input: UserInput!) {
      create_user(user_input: $user_input) {
        id
        name
        email
      }
    }
    """
  end

  def update_user do
    """
    mutation($id: ID!, $user_input: UserInput!) {
      update_user(id: $id, user_input: $user_input) {
        id
        name
        email
      }
    }
    """
  end
end
