defmodule BankAPI.Schemas.TransactionSchema do
  @moduledoc """
  Database Transaction Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias BankAPI.Schemas.AccountSchema

  @timestamps_opts type: :utc_datetime
  @optional_fields [:id, :inserted_at, :updated_at]
  @update_fields [:status]

  @type t :: %__MODULE__{
    type: String.t(),
    status: non_neg_integer(),
    amount: non_neg_integer(),
    account: AccountSchema.t()
  }

  schema "transactions" do
    field :type, Ecto.Enum, values: [:deposit, :withdraw]
    field :status, Ecto.Enum, values: [idle: 0, pending: 1, success: 2, failure: 3]
    field :amount, :integer

    belongs_to :account, AccountSchema

    timestamps()
  end

  @doc """
  Returns a valid changeset when given params is valid

  ## Examples

      iex> changeset(%{"amount" => 300, ...})
      %TransactionSchema{}

      iex> changeset(%{"amount" => "test"})
      %Ecto.Changeset{}

      iex> changeset(%{})
      %Ecto.Changeset{}
  """
  @spec changeset(map) :: __MODULE__.t() | Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, all_fields())
    |> validate_required(all_fields() -- @optional_fields)
  end

  @doc """
  Returns a valid changeset when given params is valid

  ## Examples

      iex> update_changeset(%TransactionSchema{}, %{"status" => 0})
      %TransactionSchema{}

      iex> update_changeset(%TransactionSchema{}, %{"status" => "test"})
      %Ecto.Changeset{}

      iex> update_changeset(%{})
      %Ecto.Changeset{}
  """
  @spec update_changeset(__MODULE__.t(), map) :: __MODULE__.t() | Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = transaction, params) do
    transaction
    |> cast(params, @update_fields)
    |> validate_required(all_fields())
  end

  defp all_fields, do: __MODULE__.__schema__(:fields)
end
