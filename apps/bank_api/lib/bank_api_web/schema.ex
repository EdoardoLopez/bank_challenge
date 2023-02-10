defmodule BankAPIWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom
  import_types BankAPIWeb.Schema.{
    AccountSchema,
    AccountTypes,
    TransactionSchema,
    TransactionTypes,
    UserSchema,
    UserTypes
  }

  query do
    import_fields :user_queries
    import_fields :account_queries
    import_fields :transaction_queries
  end

  # mutation do
  #   import_fields :user_mutations
  # end
end
