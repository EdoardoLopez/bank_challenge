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

  defp random_number, do: :random.uniform(100)
end
