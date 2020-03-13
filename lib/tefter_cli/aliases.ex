defmodule TefterCli.Aliases do
  alias TefterCli.Cache

  def fetch(%{force: true}), do: Cache.update(:aliases, do_fetch())
  def fetch(_), do: Cache.fetch(:aliases, fn -> do_fetch() end)

  defp do_fetch do
    case Tefter.aliases() do
      {:ok, %{status: 200, body: %{"aliases" => aliases}}} -> aliases
      _ -> []
    end
  end
end
