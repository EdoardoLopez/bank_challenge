defmodule BankAPI.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use BankAPI.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias BankAPI.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import BankAPI.DataCase
    end
  end

  setup tags do
    BankAPI.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Sandbox.start_owner!(BankAPI.Repo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  def valid_user do
    %{
      "name" => Faker.Person.first_name(),
      "email" => Faker.Internet.email()
    }
  end

  def invalid_user do
    %{
      "name" => DateTime.utc_now(),
      "email" => 10_500
    }
  end

  def valid_account(user_id) do
    %{
      "account_type" => Enum.random([0, 1]),
      "current_balance" => Enum.random(1_000..5_000),
      "state" => Enum.random(["active", "inactive"]),
      "user_id" => user_id
    }
  end

  def invalid_account(user_id) do
    %{
      "account_type" => "invalid param",
      "current_balance" => DateTime.utc_now(),
      "state" => 5_000,
      "user_id" => user_id
    }
  end

  def valid_transaction(account_id) do
    %{
      "amount" => Enum.random(300..1_000),
      "status" => Enum.random([0, 1, 2, 3]),
      "type" => Enum.random(["withdraw", "deposit"]),
      "account_id" => account_id
    }
  end

  def invalid_transaction(account_id) do
    %{
      "amount" => "Invalid value",
      "status" => DateTime.utc_now(),
      "type" => 300,
      "account_id" => account_id
    }
  end
end
