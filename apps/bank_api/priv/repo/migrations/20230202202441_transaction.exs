defmodule BankApi.Repo.Migrations.Transaction do
  use Ecto.Migration

  def up do
    create table("transactions") do
      add :type, :string
      add :status, :integer, default: 0
      add :amount, :integer, default: 0
      add :account_id, references("accounts")

      timestamps()
    end
  end

  def down do
    drop table("transactions")
  end
end
