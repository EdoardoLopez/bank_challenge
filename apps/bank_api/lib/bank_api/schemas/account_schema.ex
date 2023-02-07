defmodule BankAPI.Schemas.AccountSchema do
  @moduledoc """
  Database Account Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias BankAPI.Schemas.{TransactionSchema, UserSchema}

  @timestamps_opts type: :utc_datetime
  @optional_fields [:id]

  @type t :: %__MODULE__{
    account_type: integer(),
    current_balance: non_neg_integer(),
    state: String.t(),
    user: UserSchema.t(),
    transactions: list(TransactionSchema.t())
  }

  schema "accounts" do
    field :account_type, :integer
    field :current_balance, :integer
    field :state, :string

    belongs_to :user, UserSchema
    has_many :transactions, TransactionSchema, foreign_key: :account_id, references: :id

    timestamps()
  end

  @doc """
  Returns a valid changeset when given params is valid

  ## Examples

      iex> changeset(%{"current_balance" => 1_000, ...})
      %AccountSchema{}

      iex> changeset(%{"current_balance" => "test"})
      %Ecto.Changeset{}

      iex> changeset(%{})
      %Ecto.Changeset{}
  """
  @spec changeset(map) :: __MODULE__.t() | Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, all_fields())
    |> validate_required(all_fields() -- @optional_fields)
    |> unique_constraint([:account_type, :user_id], name: "unique_account_type_user_id")
  end

  defp all_fields, do: __MODULE__.__schema__(:fields)
end
