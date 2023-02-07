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

    create index("accounts", [:account_type, :user_id], name: "unique_account_type_user_id", unique: true)
  end

  def down do
    drop table("accounts")
    drop index("accounts", [:account_type, :user_id], name: "unique_account_type_user_id")
  end
end
