defmodule BankAPI.Repo do
  use Ecto.Repo,
    otp_app: :bank_api,
    adapter: Ecto.Adapters.Postgres

  def init(_context, config),
    do: {:ok, build_opts(config)}

  defp build_opts(opts) do
    system_opts = [
      username: System.fetch_env!("DB_USER"),
      password: System.fetch_env!("DB_PASS"),
      database: System.fetch_env!("DB_NAME"),
      hostname: System.fetch_env!("DB_HOST"),
    ]

    system_opts
    |> remove_empty_opts()
    |> merge_opts(opts)
  end

  defp merge_opts(system_opts, opts),
    do: Keyword.merge(opts, system_opts)

  defp remove_empty_opts(system_opts),
    do: Enum.reject(system_opts, fn {_k, value} -> is_nil(value) end)
end
