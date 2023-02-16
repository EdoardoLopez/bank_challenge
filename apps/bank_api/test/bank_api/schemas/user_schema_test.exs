defmodule BankAPI.SchemasTest.UserSchemaTest do
  @moduledoc """
  Tests for User schema
  """
  use BankAPI.DataCase
  alias BankAPI.Schemas.UserSchema
  alias Ecto.Adapters.SQL.Sandbox

  @expected_fields_with_types [
    {:id, :id},
    {:name, :string},
    {:email, :string},
    {:inserted_at, :utc_datetime},
    {:updated_at, :utc_datetime}
  ]

  describe "fields and types" do
    @tag :user_schema
    test "verify schema has correct fields and types" do
      actual_fields =
        for field <- UserSchema.__schema__(:fields) do
          type = UserSchema.__schema__(:type, field)
          {field, type}
        end

      assert Enum.sort(actual_fields) == Enum.sort(@expected_fields_with_types)
    end
  end

  describe "changeset/1" do
    test "success: returns a valid changeset when given valid arguments" do
      changeset = valid_user() |> UserSchema.changeset()
      assert %Changeset{valid?: true} = changeset
    end

    test "error: return an invalid changeset when given invalid argunments" do
      assert %Changeset{errors: errors} = invalid_user() |> UserSchema.changeset()

      for {field, {_msg, meta}} <- errors do
        assert errors[field], "Field #{field} is missing from errors"
        assert meta[:validation] == :cast,
          "The validation type, #{meta[:validation]}, is incorrect."
      end
    end

    test "error: return and invalid changeset when given empty params" do
      params = %{}

      assert %Changeset{errors: errors} = UserSchema.changeset(params)
      for {field, {_msg, meta}} <- errors do
        assert errors[field], "Field #{field} is missing from errors"
        assert meta[:validation] == :required,
          "The validation type, #{meta[:validation]}, is required."
      end
    end

    test "error: return and error changeset when email is duplicated" do
      Sandbox.checkout(Repo)
      {:ok, user} =
        valid_user()
        |> UserSchema.changeset()
        |> Repo.insert()

      changeset_duplicated_email =
        valid_user()
        |> Map.put("email", user.email)
        |> UserSchema.changeset()

      assert {:error, %Changeset{valid?: false, errors: errors}} =
        Repo.insert(changeset_duplicated_email)

      assert errors[:email], "The field :email is missing from errors."
      {_msg, meta} = errors[:email]

      assert meta[:constraint] == :unique,
        "The validation type, #{meta[:validation]}, is incorrect."
    end
  end
end
