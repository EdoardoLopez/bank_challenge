defmodule BankAPI.SchemasTest.AccountSchemaTest do
  @moduledoc """
  Tests for Account schema
  https://hackstore.re/episodio/proyecto-libro-azul-1x4/
  """
  use BankAPI.SchemaCase
  alias BankAPI.Schemas.{AccountSchema, UserSchema}
  alias Ecto.Adapters.SQL.Sandbox

  @expected_fields_with_types [
    {:id, :id},
    {:account_type, :integer},
    {:current_balance, :integer},
    {:state, :string},
    {:user_id, :id},
    {:inserted_at, :utc_datetime},
    {:updated_at, :utc_datetime}
  ]

  describe "fields and types" do
    @tag :account_schema
    test "verify schema has correct fields and types" do
      actual_fields =
        for field <- AccountSchema.__schema__(:fields) do
          type = AccountSchema.__schema__(:type, field)
          {field, type}
        end

      assert Enum.sort(actual_fields) == Enum.sort(@expected_fields_with_types)
    end
  end

  describe "changeset/1" do
    test "success: returns a valid changeset when given valid arguments" do
      valid_params = valid_params(@expected_fields_with_types)

      changeset = AccountSchema.changeset(valid_params)
      assert %Changeset{valid?: true} = changeset
    end

    test "error: return an invalid changeset when given invalid argunments" do
      invalid_params = invalid_params(@expected_fields_with_types)

      assert %Changeset{errors: errors} = AccountSchema.changeset(invalid_params)

      for {field, {_msg, meta}} <- errors do
        assert errors[field], "Field #{field} is missing from errors"
        assert meta[:validation] == :cast,
          "The validation type, #{meta[:validation]}, is incorrect."
      end
    end

    test "error: return and invalid changeset when given empty params" do
      params = %{}

      assert %Changeset{errors: errors} = AccountSchema.changeset(params)
      for {field, {_msg, meta}} <- errors do
        assert errors[field], "Field #{field} is missing from errors"
        assert meta[:validation] == :required,
          "The validation type, #{meta[:validation]}, is required."
      end
    end

    test "error: return and invalid changeset when account and user is duplicated" do
      Sandbox.checkout(Repo)
      {:ok, user} = new_user()
      {:ok, account} = new_account(user)

      changeset_duplicated =
        valid_params(@expected_fields_with_types)
        |> Map.put("account_type", account.account_type)
        |> Map.put("user_id", account.user_id)
        |> AccountSchema.changeset()

      assert {:error, %Changeset{valid?: false, errors: errors}} =
        Repo.insert(changeset_duplicated)

      assert errors[:account_type], "The field :account_type is missing from errors."
      {_msg, error} = errors[:account_type]

      assert error[:constraint] == :unique,
        "The validation type, #{error[:validation]}, is incorrect."
    end
  end

  defp new_user do
    valid_params(@expected_fields_with_types)
    |> Map.put("name", Faker.Name.first_name())
    |> Map.put("email", Faker.Internet.email())
    |> UserSchema.changeset()
    |> Repo.insert()
  end

  defp new_account(user) do
    valid_params(@expected_fields_with_types)
    |> Map.put("user_id", user.id)
    |> AccountSchema.changeset()
    |> Repo.insert()
  end
end
