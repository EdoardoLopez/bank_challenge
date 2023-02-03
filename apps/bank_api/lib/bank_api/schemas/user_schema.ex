defmodule BankAPI.Schemas.UserSchema do
  @moduledoc """
  Database User Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias BankAPI.Schemas.AccountSchema

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
end
