alias BankAPI.Methods.TransactionMethods
alias BankAPI.Repo
alias BankAPI.Schemas.{AccountSchema, UserSchema}

transactions = [
  %{amount: 1000, type: :deposit},
  %{amount: 200, type: :deposit},
  %{amount: 1500, type: :withdraw},
  %{amount: 700, type: :withdraw},
  %{amount: 300, type: :deposit},
]

user = 
  %UserSchema{
    name: Faker.Person.first_name(),
    email: Faker.Internet.email()
  }
  |> Repo.insert!()

account =
  %AccountSchema{
    state: :active,
    account_type: :debit,
    user_id: user.id
  }
  |> Repo.insert!()

Enum.each(transactions, fn transaction ->
  Map.put(transaction, :account_id, account.id)
  |> TransactionMethods.create_transaction()
end)