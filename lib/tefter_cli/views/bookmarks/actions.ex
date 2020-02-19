defmodule TefterCli.Views.Bookmarks.Actions do
  @moduledoc """
  Module handling interactions of Bookmark resources with Tefter
  """

  alias TefterCli.Cache

  def create(url) do
    case Tefter.create_bookmark(%{url: url}) do
      {:ok, %{status: s, body: bookmark}} when s in 200..299 -> {:ok, bookmark}
      error -> error
    end
  end

  def delete(id) do
    case Tefter.delete_bookmark(%{id: id}) do
      {:ok, _} ->
        updated_bookmarks = Cache.read(:bookmarks) |> Enum.reject(&match?(%{id: ^id}, &1))
        Cache.update(:bookmarks, updated_bookmarks)

        {:ok, updated_bookmarks}

      error ->
        error
    end
  end
end
