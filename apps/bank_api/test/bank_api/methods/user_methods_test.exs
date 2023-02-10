defmodule BankAPI.MethodsTest.UserMethodsTest do
  @moduledoc """
  Tests for user methods
  """
  use BankAPI.DataCase
  alias BankAPI.Methods.UserMethods
  alias BankAPI.Schemas.UserSchema

  setup do
    %{
      user_params: fn -> %{
        "name" => Faker.Person.first_name(),
        "email" => Faker.Internet.email()
      } end,
      random_id: fn -> Enum.random(100..200) end
    }
  end

  describe "get_user/1" do
    test "success: returns a user from DB" do
      {:ok, user} = create_user()

      assert {:ok, get_user} = UserMethods.get_user(user.id)

      assert user == get_user
    end

    test "error: return error tuple when an user doesn't exist", %{random_id: id} do
      assert {:error, msg} = UserMethods.get_user(id.())

      assert msg == "not found"
    end
  end

  describe "create/1" do
    test "success: it return an user when is inserted into db" do
      assert {:ok, %UserSchema{} = created_user} = create_user()
      user_db = Repo.get(UserSchema, created_user.id)

      assert created_user == user_db
    end

    test "error: return an error tuple when user can't be created" do
      assert {:error, %Ecto.Changeset{valid?: false}} = UserMethods.create_user(%{})
    end
  end

  describe "update/2" do
    test "success: it updates an user into db and return it" do
      assert {:ok, user_inserted} = create_user()

      new_params = %{name: Faker.Person.first_name()}

      assert {:ok, user_updated} = UserMethods.update_user(user_inserted, new_params)
      user_db = Repo.get(UserSchema, user_updated.id)

      assert user_db == user_updated
      refute user_db == user_inserted
    end

    test "error: return an error tuple when user can't be updated" do
      assert {:ok, user_inserted} = create_user()
      invalid_params = %{"name" => DateTime.utc_now()}

      assert {:error, %Ecto.Changeset{valid?: false}} =
        UserMethods.update_user(user_inserted, invalid_params)

      assert user_inserted == Repo.get(UserSchema, user_inserted.id)
    end
  end

  describe "delete/1" do
    test "success: it delete and user from db" do
      assert {:ok, user_inserted} = create_user()

      assert {:ok, deleted_user} = UserMethods.delete_user(user_inserted)

      refute Repo.get(UserSchema, deleted_user.id)
    end
  end

  defp create_user, do: valid_user() |> UserMethods.create_user()
end
