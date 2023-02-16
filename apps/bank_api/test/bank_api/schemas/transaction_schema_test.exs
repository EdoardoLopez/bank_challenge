defmodule BankAPI.SchemasTest.TransactionSchemaTest do
  @moduledoc """
  Tests for Transaction schema
  """
  use BankAPI.DataCase
  alias BankAPI.Schemas.TransactionSchema

  @expected_fields_with_types [
    {:id, :id},
    {:amount, :integer},
    {:account_id, :id},
    {:type, :string},
    {:status, :integer},
    {:inserted_at, :utc_datetime},
    {:updated_at, :utc_datetime}
  ]

  describe "fields and types" do
    @tag :transaction_schema
    test "verify schema has correct fields and types" do
      actual_fields =
        for field <- TransactionSchema.__schema__(:fields) do
          type = TransactionSchema.__schema__(:type, field) |> field_type()
          {field, type}
        end

      assert Enum.sort(actual_fields) == Enum.sort(@expected_fields_with_types)
    end
  end

  describe "changeset/1" do
    test "success: returns a valid changeset when given valid arguments" do
      changeset = valid_transaction(123) |> TransactionSchema.changeset()
      assert %Changeset{valid?: true} = changeset
    end

    test "error: return an invalid changeset when given invalid argunments" do
      assert %Changeset{errors: errors} = invalid_transaction(532) |> TransactionSchema.changeset()

      for {field, {_msg, meta}} <- errors do
        assert errors[field], "Field #{field} is missing from errors"
        assert meta[:validation] == :cast,
          "The validation type, #{meta[:validation]}, is incorrect."
      end
    end

    test "error: return and invalid changeset when given empty params" do
      params = %{}

      assert %Changeset{errors: errors} = TransactionSchema.changeset(params)
      for {field, {_msg, meta}} <- errors do
        assert errors[field], "Field #{field} is missing from errors"
        assert meta[:validation] == :required,
          "The validation type, #{meta[:validation]}, is required."
      end
    end
  end
end
