defmodule TefterCli.Bookmarks do
  alias TefterCli.Cache

  def fetch(%{force: true}), do: Cache.update(:bookmarks, do_fetch())
  def fetch(_), do: Cache.fetch(:bookmarks, fn -> do_fetch() end)

  defp do_fetch do
    case Tefter.bookmarks_export() do
      {:ok, %{status: 200, body: bookmarks}} -> bookmarks
      _ -> []
    end
  end
end
