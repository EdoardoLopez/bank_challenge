defmodule BankAPI.Repo.Migrations.Account do
  use Ecto.Migration

  def up do
    create table("accounts") do
      add :account_type, :integer
      add :current_balance, :integer, default: 0
      add :state, :string
      add :user_id, references("users")

      timestamps()
    end
  end

  def down do
    drop table("accounts")
  end
end
