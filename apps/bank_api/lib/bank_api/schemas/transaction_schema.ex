defmodule BankAPI.Schemas.TransactionSchema do
  @moduledoc """
  Database Transaction Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias BankAPI.Schemas.AccountSchema

  @type t :: %__MODULE__{
    type: String.t(),
    status: non_neg_integer(),
    amount: non_neg_integer(),
    account: AccountSchema.t()
  }

  schema "transactions" do
    field :type, :string
    field :status, :integer
    field :amount, :integer

    belongs_to :account, AccountSchema

    timestamps()
  end
end
