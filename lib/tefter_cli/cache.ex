defmodule TefterCli.Cache do
  @moduledoc """
  File-backed cache
  The cache contents are kept as a JSON Object.
  """

  @cache "~/.tefter_cache"

  @doc "Retrieve a value from the cache if exists, otherwise call the given function to initialise and return it"
  def fetch(key, fun) do
    read(key) || update(key, fun.())
  end

  @doc "Return all the contents of the cache as a map"
  def read do
    with {:ok, f} <- File.read(cache_path()),
         {:ok, json} <- Jason.decode(f, keys: :atoms) do
      json
    else
      _ -> %{}
    end
  end

  @doc "Return a value of the cache"
  def read(key), do: read()[key]

  @doc "Update a value of the cache"
  def update(key, value) do
    with {:ok, json} <- read() |> put_in([key], value) |> Jason.encode(),
         File.write(cache_path(), json) do
      read(key)
    else
      error -> error
    end
  end

  defp cache_path, do: Path.expand(@cache)
end
