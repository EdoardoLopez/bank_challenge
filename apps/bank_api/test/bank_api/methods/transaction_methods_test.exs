defmodule BankAPI.MethodsTest.TransactionMethodsTest do
  @moduledoc """
  Tests for transactions methods
  """
  use BankAPI.DataCase
  alias BankAPI.Methods.{AccountMethods, TransactionMethods, UserMethods}
  alias BankAPI.Schemas.TransactionSchema

  describe "get_transaction/1" do
    test "success: it returns a transaction from db" do
      {:ok, account} = create_account()
      assert {:ok, %{transaction: transaction}} =
        valid_transaction(account.id)
        |> TransactionMethods.create_transaction()

      assert transaction == Repo.get(TransactionSchema, transaction.id)
    end

    test "error: return error tuple when a transaction doesn't exist" do
      assert {:error, msg} = TransactionMethods.get_transaction(158)

      assert msg == "not found"
    end
  end

  describe "create_transaction/1" do
    test "success: it returns a transaction when is inserted into db" do
      {:ok, account} = create_account()

      assert {:ok, %{account: account_updated, transaction: transaction}} =
        valid_transaction(account.id)
        |> TransactionMethods.create_transaction()

      new_balance =
        if transaction.type == :deposit do
          account.current_balance + transaction.amount
        else
          account.current_balance - transaction.amount
        end

      assert transaction == Repo.get(TransactionSchema, transaction.id)

      assert account_updated.current_balance == new_balance
    end

    test "error: return an error tuple when transaction can't be created" do
      {:ok, account} = create_account()

      assert {:error, %Ecto.Changeset{valid?: false}} =
        TransactionMethods.create_transaction(invalid_transaction(account.id))
    end
  end

  describe "update_transacrion/2" do
    test "success: it updates an transaction into db and return it" do
      {:ok, account} = create_account()

      assert {:ok, %{transaction: transaction}} =
        valid_transaction(account.id)
        |> TransactionMethods.create_transaction()

      assert {:ok, transaction_updated} =
        TransactionMethods.update_transaction(transaction, %{"status" => 3})

      {:ok, transaction_db} = TransactionMethods.get_transaction(transaction_updated.id)

      assert transaction_db == transaction_updated
      refute transaction == transaction_updated
    end

    test "error: return an error tuple when transaction can't be updated" do
      {:ok, account} = create_account()

      assert {:ok, %{transaction: transaction}} =
        valid_transaction(account.id)
        |> TransactionMethods.create_transaction()

      assert {:error, %Ecto.Changeset{valid?: false}} =
        TransactionMethods.update_transaction(transaction, %{"status" => "invalid value"})

      assert transaction == Repo.get(TransactionSchema, transaction.id)
    end
  end

  defp create_account do
    {:ok, user} = UserMethods.create_user(valid_user())

    valid_account(user.id)
    |> Map.put("state", "active")
    |> AccountMethods.create_account()
  end
end
