defmodule BankAPI.Methods.UserMethods do
  @moduledoc """
  Methods for User
  """

  alias BankAPI.{Repo, Schemas.UserSchema, Utils}
  alias Ecto.Changeset

  @doc """
  Return all users from database.

  ## Examples
      iex> users()
      []

      iex> users()
      [%UserSchema{}, ...]
  """
  @spec users() :: list(UserSchema.t())
  def users do
    UserSchema
    |> Repo.all()
  end

  @doc """
  Return an user from database.

  ## Examples
      iex> get_user(2)
      {:ok, %UserSchema{}}

      iex> get_user(30)
      {:error, "not found"}
  """
  @spec get_user(non_neg_integer()) :: {:ok, UserSchema.t()} | {:error, String.t()}
  def get_user(id) do
    UserSchema
    |> Repo.get(id)
    |> case do
      nil -> {:error, "not found"}
      user -> {:ok, user}
    end
  end

  @doc """
  Insert an user to database.

  ## Examples
      iex> create_user(%{"name" => "Example name"})
      {:ok, %UserSchema{}}

      iex> create_user(%{})
      {:error, %Ecto.Changeset{}}
  """
  @spec create_user(map) :: {:ok, UserSchema.t()} | {:error, Ecto.Changeset.t()}
  def create_user(params) when is_map(params) do
    UserSchema.changeset(params)
    |> Repo.insert()
  end
  def create_user(_params), do: params_error()

  @doc """
  Update an user from database.

  ## Examples
      iex> update_user(user_from_db, %{"name" => "Example name"})
      {:ok, %UserSchema{}}

      iex> update_user(user_from_db, %{"name" => invalid_data})
      {:error, %Ecto.Changeset{}}
  """
  @spec update_user(UserSchema.t(), map) :: {:ok, UserSchema.t()} | {:error, Ecto.Changeset.t()}
  def update_user(%UserSchema{} = user, params) when is_struct(user) and is_map(params) do
    user
    |> UserSchema.update_changeset(params)
    |> Repo.update()
  end
  def update_user(_id, _params), do: params_error()

  @doc """
  Delete an user from database.

  ## Examples
      iex> delete_user(user_from_db)
      {:ok, %UserSchema{}}

      iex> delete_user(user_from_db)
      {:error, %Ecto.Changeset{}}
  """
  @spec delete_user(map) :: {:ok, UserSchema.t()} | {:error, Ecto.Changeset.t()}
  def delete_user(%UserSchema{} = user) when is_struct(user) do
    Repo.delete(user)
  end
  def delete_user(_user), do: params_error()

  defp params_error, do: {:error, "one or more given params are invalid"}
end
