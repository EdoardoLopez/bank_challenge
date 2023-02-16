defmodule BankAPI.MethodsTest.AccountMethodsTest do
  @moduledoc """
  Tests for account methods
  """
  use BankAPI.DataCase
  alias BankAPI.Methods.{AccountMethods, UserMethods}
  alias BankAPI.Schemas.AccountSchema

  describe "get_account/1" do
    test "success: returns a account from DB" do
      {:ok, user} = create_user()
      {:ok, account} = create_account(user.id)

      assert {:ok, get_account} = AccountMethods.get_account(account.id)

      assert account == get_account
    end

    test "error: return error tuple when an account doesn't exist" do
      assert {:error, msg} = AccountMethods.get_account(Enum.random(300..1_000))

      assert msg == "not found"
    end
  end

  describe "create/1" do
    test "success: it return an account when is inserted into db" do
      assert {:ok, user} = create_user()
      assert {:ok, %AccountSchema{} = account_created} = create_account(user.id)

      account_db = Repo.get(AccountSchema, account_created.id)

      assert account_created == account_db
    end

    test "error: return an error tuple when account can't be created" do
      assert {:error, %Ecto.Changeset{valid?: false}} = AccountMethods.create_account(%{})
    end
  end

  describe "update/2" do
    test "success: it updates an account into db and return it" do
      assert {:ok, user} = create_user()
      assert {:ok, %AccountSchema{} = account_created} = create_account(user.id)

      new_params = valid_account(user.id)
      assert {:ok, account_updated} = AccountMethods.update_account(account_created, new_params)

      account_db = Repo.get(AccountSchema, account_updated.id)

      assert account_db == account_updated
      refute account_db == account_created
    end

    test "error: return an error tuple when account can't be updated" do
      assert {:ok, user} = create_user()
      assert {:ok, account_created} = create_account(user.id)
      invalid_params = %{"current_balance" => "invalid param"}

      assert {:error, %Ecto.Changeset{valid?: false}} =
        AccountMethods.update_account(account_created, invalid_params)

      assert account_created == Repo.get(AccountSchema, account_created.id)
    end
  end

  describe "delete/1" do
    test "success: it delete and account from db" do
      assert {:ok, user} = create_user()
      assert {:ok, account_created} = create_account(user.id)

      assert {:ok, deleted_account} = AccountMethods.delete_account(account_created)

      refute Repo.get(AccountSchema, deleted_account.id)
    end
  end

  defp create_user, do: valid_user() |> UserMethods.create_user()

  defp create_account(user_id) do
    valid_account(user_id)
    |> AccountMethods.create_account()
  end
end
