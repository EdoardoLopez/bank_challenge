defmodule BankAPI.Schemas.UserSchema do
  @moduledoc """
  Database User Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias BankAPI.Schemas.AccountSchema

  @timestamps_opts type: :utc_datetime
  @optional_fields [:id, :inserted_at, :updated_at]

  @type t :: %__MODULE__{
    name: String.t(),
    email: String.t(),
    accounts: list(AccountSchema.t())
  }

  schema "users" do
    field :name, :string
    field :email, :string

    has_many :accounts, AccountSchema, foreign_key: :user_id, references: :id

    timestamps()
  end

  @doc """
  Returns a valid changeset when given params is valid

  ## Examples

      iex> changeset(%{"name" => "Example", ...})
      %UserSchema{}

      iex> changeset(%{"name" => 103})
      %Ecto.Changeset{}

      iex> changeset(%{})
      %Ecto.Changeset{}
  """
  @spec changeset(map) :: __MODULE__.t() | Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, all_fields())
    |> validate_required(all_fields() -- @optional_fields)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r'^[\w.!#$%&’*+\-/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)')
  end

  @doc """
  Returns a valid changeset when given params is valid

  ## Examples

      iex> update_changeset(%UserSchema{}, %{"name" => "Example", ...})
      %UserSchema{}

      iex> update_changeset(%UserSchema{}, %{"name" => 103})
      %Ecto.Changeset{}
  """
  @spec update_changeset(__MODULE__.t(), map) :: __MODULE__.t() | Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, all_fields())
    |> unique_constraint(:email)
    |> validate_format(:email, ~r'^[\w.!#$%&’*+\-/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)')
  end

  defp all_fields, do: __MODULE__.__schema__(:fields)
end
