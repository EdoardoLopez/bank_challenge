defmodule BankAPI.Methods.AccountMethods do
  @moduledoc """
  Methods for Accounts
  """
  import Ecto.Query
  alias BankAPI.{Repo, Schemas.AccountSchema, Utils}
  alias Ecto.Changeset

  @doc """
  Return all accounts from database.

  ## Examples
      iex> accounts()
      []

      iex> accounts()
      [%AccountSchema{}, ...]
  """
  @spec accounts() :: list(AccountSchema.t())
  def accounts do
    AccountSchema
    |> Repo.all()
  end

  @doc """
  Similar to `accounts/0`, it allow pass a filter and retrieve specific data.

  ## Options
    * `:filter` - Filter is used to retrieve specific data, allowed filters are:
        - `:account_type`
        - `:state`
        - `:user_id`

  ## Examples
      iex> accounts(%{filter: %{user_id: 10}})
      [%AccountSchema{}, ...]
  """
  @spec accounts(map()) :: list(AccountSchema.t())
  def accounts(args) do
    Enum.reduce(args, AccountSchema, fn
      {:filter, filter}, query ->
        account_filter_with(query, filter)
    end)
    |> Repo.all()
  end

  defp account_filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:account_type, account_type}, query ->
        from(q in query, where: q.account_type == ^account_type)
      {:state, state}, query ->
        from(q in query, where: q.state == ^state)
      {:user_id, user_id}, query ->
        from(q in query, where: q.user_id == ^user_id)
    end)
  end

  @doc """
  Return an account from database.

  ## Examples
      iex> get_account(2)
      {:ok, %AccountSchema{}}

      iex> get_account(30)
      {:error, "not found"}
  """
  @spec get_account(non_neg_integer()) :: {:ok, AccountSchema.t()} | {:error, String.t()}
  def get_account(id) do
    AccountSchema
    |> Repo.get(id)
    |> case do
      nil -> {:error, "not found"}
      account -> {:ok, account}
    end
  end

  @doc """
  Insert an account to database.

  ## Examples
      iex> create_account(%{"current_balance" => 3_000})
      {:ok, %AccountSchema{}}

      iex> create_account(%{})
      {:error, %Ecto.Changeset{}}
  """
  @spec create_account(map) :: {:ok, AccountSchema.t()} | {:error, Ecto.Changeset.t()}
  def create_account(params) when is_map(params) do
    AccountSchema.changeset(params)
    |> Repo.insert()
  end
  def create_account(_params), do: params_error()

  @doc """
  Update an account from database.

  ## Examples
      iex> update_account(account_from_db, %{"current_balance" => 3_000})
      {:ok, %AccountSchema{}}

      iex> update_account(account_from_db, %{"current_balance" => "invalid_param"})
      {:error, %Ecto.Changeset{}}
  """
  @spec update_account(AccountSchema.t(), map) ::{:ok, AccountSchema.t()} | {:error, Ecto.Changeset.t()}
  def update_account(%AccountSchema{} = account, params) when is_struct(account) and is_map(params) do
    account
    |> AccountSchema.update_changeset(params)
    |> Repo.update()
  end
  def update_account(_id, _params), do: params_error()

  @doc """
  Delete an account from database.

  ## Examples
      iex> delete_account(account_from_db)
      {:ok, %AccountSchema{}}

      iex> delete_account(account_from_db)
      {:error, %Ecto.Changeset{}}
  """
  @spec delete_account(map) :: {:ok, AccountSchema.t()} | {:error, Ecto.Changeset.t()}
  def delete_account(%AccountSchema{} = account) when is_struct(account) do
    Repo.delete(account)
  end
  def delete_account(_account), do: params_error()

  defp params_error, do: {:error, "one or more given params are invalid"}
end
