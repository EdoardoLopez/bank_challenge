defmodule BankAPI.Schemas.AccountSchema do
  @moduledoc """
  Database Account Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias BankAPI.Schemas.{UserSchema, TransactionSchema}

  @type t :: %__MODULE__{
    account_type: String.t(),
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
end
