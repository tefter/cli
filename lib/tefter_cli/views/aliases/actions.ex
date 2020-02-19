defmodule TefterCli.Views.Aliases.Actions do
  @moduledoc """
  Module handling interactions of Alias resources with Tefter
  """

  def create(input) do
    with {:ok, input} <- process_input(input),
         {:ok, %{status: s, body: alias}} when s in 200..299 <- Tefter.create_alias(input) do
      {:ok, alias}
    else
      error -> error
    end
  end

  def delete(id) do
    case Tefter.delete_alias(%{id: id}) do
      {:ok, _} ->
        {:ok, id}

      error ->
        error
    end
  end

  defp process_input(input) do
    case String.split(input, " ") do
      [alias, url] -> {:ok, %{alias: alias, url: url}}
      _ -> {:error, :invalid_format}
    end
  end
end
