defmodule BankUI.GraphQLClient do
  @moduledoc """
  HTTP Client to perform GraphQL requests
  """
  @type graphql_response :: %{
    data: map(),
    errors: list(map())
  }

  @doc """
  Make a request to GraphQL server

    ## Examples
      iex> user_q = BankUI.Queries.UserQuery.user()
      iex> list_users_q = BankUI.Queries.UserQuery.users()

      iex> GraphQLClient.post(list_users_q)
      {:ok, %{"data" => %{}}}

      iex> GraphQLClient.post(user_q, %{id: "invalid value"})
      {:ok, %{"errors" => []}

      iex> GraphQLClient.post(users_query)
      {:ok, %{"data" => %{}}}

      iex> GraphQLClient.post("")
      ArgumentError
  """
  @spec post(String.t(), map(), String.t()) :: {:ok, graphql_response()} | {:error, map()}
  def post(query, data \\ %{}, endpoint \\ "") do
    endpoint
    |> base_url()
    |> HTTPoison.post(encode_data(query, data), [{"Content-Type", "application/json"}])
    |> handle_response()
  end

  # Handle HTTPoison response and return only HTTP body.
  @spec handle_response(HTTPoison.Response.t()) :: {:ok, graphql_response()} | {:error, map()}
  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: sts_code} = response} when sts_code in 200..299 ->
        {:ok, Jason.decode!(response.body)}
      {:ok, %HTTPoison.Response{status_code: sts_code} = response} when sts_code in 400..599 ->
        {:error, Jason.decode!(response.body)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{reason: reason}}
    end
  end

  # Encode query and variables with "Jason" to send to GraphQL server
  defp encode_data("", _data) do
    raise ArgumentError, """
    A query is required to perform GraphQL requests.
    """
  end
  defp encode_data(query, data) when map_size(data) == 0, do: %{query: query} |> Jason.encode!()
  defp encode_data(query, data), do: %{query: query, variables: data} |> Jason.encode!()

  defp base_url(endpoint \\ ""),
    do: Application.get_env(:bank_ui, :api_url) <> "/" <> endpoint
end
