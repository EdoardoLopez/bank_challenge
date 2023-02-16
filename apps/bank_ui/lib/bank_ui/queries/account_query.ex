defmodule BankUI.Queries.AccountQuery do
  @moduledoc """
  Account queries with GraphQL format.
  """
  def list_accounts do
    """
    query($account_filter: AccountFilter!) {
      accounts(account_filter: $account_filter) {
        id
        state
        account_type
        current_balance
        transactions {
          id
          amount
          status
          type
          inserted_at
          updated_at
        }
      }
    }
    """
  end

   def fetch_account do
    """
    query($id: ID!) {
      account(id: $id) {
        id
        state
        account_type
        current_balance
        transactions {
          id
          amount
          status
          type
          inserted_at
          updated_at
        }
      }
    }
    """
  end

  def create_account do
    """
    mutation($account_input: AccountInput!) {
      create_account(account_input: $account_input) {
        id
        state
        account_type
        current_balance
        transactions {
          id
          amount
          status
          type
          inserted_at
          updated_at
        }
      }
    }
    """
  end

  def update_account do
    """
    mutation($id: ID!, $account_input: AccountInput!) {
      update_account(id: $id, account_input: $account_input) {
        id
        state
        account_type
        current_balance
        transactions {
          id
          amount
          status
          type
          inserted_at
          updated_at
        }
      }
    }
    """
  end
end
