defmodule BankAPI.SchemaCase do
  @moduledoc false
  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias BankAPI.Repo
      alias Ecto.Changeset
      import BankAPI.SchemaCase
    end
  end

  setup _ do
    Sandbox.mode(BankAPI.Repo, :manual)
  end

  def valid_params(field_with_types) do
    valid_by_type = %{
      id: fn -> random_number() end,
      integer: fn -> random_number() end,
      string: fn -> Faker.Lorem.word() end,
      utc_datetime: fn -> DateTime.utc_now() end
    }

    for {field, type} <- field_with_types, into: %{} do
      {Atom.to_string(field), valid_by_type[type].()}
    end
  end

  def invalid_params(field_with_types) do
    valid_by_type = %{
      id: fn -> Faker.Lorem.word() end,
      integer: fn -> Faker.Lorem.word() end,
      string: fn -> random_number() end,
      utc_datetime: fn -> random_number() end
    }

    for {field, type} <- field_with_types, into: %{} do
      {Atom.to_string(field), valid_by_type[type].()}
    end
  end

  def account do
    %{
      "account_type" => fn -> Enum.random([0, 1]) end,
      "state" => fn -> Enum.random(["active", "inactive"]) end
    }
  end

  def transaction do
    %{
      "type" => fn -> Enum.random(["deposit", "withdraw"]) end,
      "status" => fn -> Enum.random([0, 1, 2, 3]) end
    }
  end

  def field_type(type) when is_tuple(type), do: elem(type, 2).type
  def field_type(type), do: type

  defp random_number, do: :random.uniform(100)
end
