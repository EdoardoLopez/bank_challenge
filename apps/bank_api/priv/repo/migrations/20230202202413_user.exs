defmodule BankApi.Repo.Migrations.User do
  use Ecto.Migration

  def up do
    create table("users") do
      add :name, :string
      add :email, :string

      timestamps()
    end

    create index("users", [:email], unique: true)
  end

  def down do
    drop table("users")
    drop index("users", [:email])
  end
end
