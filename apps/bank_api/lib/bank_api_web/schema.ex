defmodule BankAPIWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom
  import_types BankAPIWeb.Schema.AccountSchema
  import_types BankAPIWeb.Schema.AccountTypes
  import_types BankAPIWeb.Schema.TransactionSchema
  import_types BankAPIWeb.Schema.TransactionTypes
  import_types BankAPIWeb.Schema.UserSchema
  import_types BankAPIWeb.Schema.UserTypes

  query do
    import_fields :user_queries
    import_fields :account_queries
    import_fields :transaction_queries
  end

  mutation do
    import_fields :user_mutations
    import_fields :account_mutations
    import_fields :transaction_mutations
  end
end
