defmodule BankAPI.Utils do
  @moduledoc """
  Utils functions
  """
  @type error :: %{
    field: String.t(),
    message: String.t()
  }

  @doc """
  Converts an atom key map to a string key map

  ## Examples

      iex> atom_map = %{name: "Example", phone: 0123456789}
      iex> convert_atom_map_to_string(atom_map)
      %{"name" => "Example", "phone" => 0123456789}
  """
  @spec convert_atom_map_to_string(map()) :: map()
  def convert_atom_map_to_string(map) do
    for {key, value} <- map, into: %{} do
      {
        if(is_atom(key), do: Atom.to_string(key), else: key),
        value
      }
    end
  end

  @doc """
  Handle any schemas response and format it.

  > Note: this function is not recommended to use directly with `Ecto.Multi` responses.
    If is the case you will need add extra manipulation to handle response correctly.

  ## Examples
      iex> UserMethods.create_user(%{"name" => "Example"}) |> handle_upsert_responses()
      {:ok, %UserSchema{}}

      iex> AccountMethods.create_account(%{"current_balance" => "invalid value"}) |> handle_upsert_responses()
      {:error, [%{field: "current_balance", message: "invalid value"}, ...]}
  """
  @spec handle_upsert_responses(Ecto.Schema.t()) ::
    {:ok, Ecto.Schema.t()} | {:error, list(error())}
  def handle_upsert_responses(response) do
    case response do
    {:ok, schema} ->
      {:ok, schema}
    {:error, changeset} ->
      {:error, transform_errors(changeset)}
    end
  end

  @doc """
  Transform Ecto.Changeser errors list into a list of map errors

  ## Examples

      iex> transform_errors(%Ecto.Changeset{})
      [%{field: "example", message: "invalid field"}, ...]
  """
  @spec transform_errors(Ecto.Changeset.t()) :: list(error())
  def transform_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &format_error/1)
    |> Enum.map(fn {key, msg} ->
      %{field: key, message: List.first(msg)}
    end)
  end

  defp format_error({msg, opts}) do
    for {key, value} <- opts, is_atom(value), reduce: msg do
      acc -> String.replace(acc, "%{#{key}}", to_string(value))
    end
  end
end
