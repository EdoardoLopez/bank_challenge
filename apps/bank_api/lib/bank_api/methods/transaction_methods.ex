defmodule BankAPI.Methods.TransactionMethods do
  @moduledoc """
  Methods for Transactions
  """
  import Ecto.Query
  alias BankAPI.{Methods.AccountMethods, Repo, Schemas.AccountSchema, Schemas.TransactionSchema, Utils}
  alias Ecto.{Changeset, Multi}

  @doc """
  Return all transactions from database.

  ## Examples
      iex> transactions()
      []

      iex> transactions()
      [%TransactionSchema{}, ...]
  """
  @spec transactions() :: list(TransactionSchema.t())
  def transactions do
    TransactionSchema
    |> Repo.all()
  end

  @doc """
  Similar to `transactions/0`, it allow pass a filter and retrieve specific data.

  ## Options
    * `:filter` - Filter is used to retrieve specific data, allowed filters are:
        - `:type`
        - `:status`
        - `:account_id`

  ## Examples
      iex> transactions(%{filter: %{account_id: 10}})
      [%TransactionSchema{}, ...]
  """
  @spec transactions(map()) :: list(TransactionSchema.t())
  def transactions(args) do
    Enum.reduce(args, TransactionSchema, fn
      {:filter, filter}, query ->
        transaction_filter_with(query, filter)
    end)
    |> Repo.all()
  end

  defp transaction_filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:status, status}, query ->
        from(q in query, where: q.status == ^status)
      {:type, type}, query ->
        from(q in query, where: q.type == ^type)
      {:account_id, account_id}, query ->
        from(q in query, where: q.account_id == ^account_id)
    end)
  end

  @doc """
  Return a transaction from database.

  ## Examples
      iex> get_transaction(2)
      {:ok, %TransactionSchema{}}

      iex> get_transaction(30)
      {:error, "not found"}
  """
  @spec get_transaction(non_neg_integer()) :: {:ok, TransactionSchema.t()} | {:error, String.t()}
  def get_transaction(id) when is_integer(id) do
    TransactionSchema
    |> Repo.get(id)
    |> case do
      nil -> {:error, "not found"}
      transaction -> {:ok, transaction}
    end
  end
  def get_transaction(_id), do: params_error()

  @doc """
  Insert an transaction to database.

  ## Examples
      iex> create_transaction(%{"current_balance" => 3_000})
      {:ok, %{account: %AccountSchema{}, transaction: %TransactionSchema{}}}

      iex> create_transaction(%{})
      {:error, %Ecto.Changeset{}}
  """
  @spec create_transaction(map) ::
    {:ok, %{account: AccountSchema.t(), transaction: TransactionSchema.t()}} | {:error, Ecto.Changeset.t()}
  def create_transaction(params) when is_map(params) do
    with {:ok, account} <- AccountMethods.get_account(params["account_id"]),
         true <- account.state == :active,
         {:ok, new_balance} <- calculate_balance(account.current_balance, params["amount"], params["type"]) do

      transaction_schema =
        Map.put(params, "status", 2)
        |> TransactionSchema.changeset()

      Multi.new()
      |> Multi.insert(:transaction, transaction_schema)
      |> Multi.update(:account, AccountSchema.update_changeset(account, %{"current_balance" => new_balance}))
      |> Repo.transaction()
    else
      {:error, msg} when msg == "not found" ->
        {:error, "account not found, transaction can't be processed"}
      false ->
        {:error, "can't make transactions into inactive account"}
      {:error, msg} ->
        Map.put(params, "status", 3)
        |> TransactionSchema.changeset()
        |> Repo.insert()
        |> case do
          {:ok, _transaction} ->
            {:error, msg}
          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end
  def create_transaction(_params), do: params_error()

  @doc """
  Update an transaction from database. 

  > Note: Only `:status` field can be updated.

  ## Examples
      iex> update_transaction(transaction_from_db, %{"status" => 0})
      {:ok, %TransactionSchema{}}

      iex> update_transaction(transaction_from_db, %{"status" => "invalid_param"})
      {:error, %Ecto.Changeset{}}
  """
  @spec update_transaction(TransactionSchema.t(), map) ::{:ok, TransactionSchema.t()} | {:error, Ecto.Changeset.t()}
  def update_transaction(%TransactionSchema{} = transaction, params) when is_struct(transaction) and is_map(params) do
    transaction
    |> TransactionSchema.update_changeset(params)
    |> Repo.update()
  end
  def update_transaction(_id, _params), do: params_error()

  defp params_error, do: {:error, "one or more given params are invalid"}

  defp calculate_balance(current_balance, amount, type) when type == "deposit" do
    {:ok, current_balance + amount}
  end
  defp calculate_balance(current_balance, amount, type) when type == "withdraw" do
    if amount <= current_balance do
      {:ok, current_balance - amount}
    else
      {:error, "insufficient balance"}
    end
  end
  defp calculate_balance(_current_balance, _amount, _type),
    do: {:error, "invalid transaction type"}
end
