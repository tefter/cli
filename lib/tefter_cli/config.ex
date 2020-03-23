defmodule TefterCli.Config do
  @moduledoc """
  File-backed configuration.
  The config is meant to primarily store the authentication token of the user.
  """

  @config "~/.tefter"
  @key :tefter_cli_config

  require Logger

  @doc "Return all the configuration"
  def all, do: :persistent_term.get(@key, do_all())

  @doc "Update the configuration with values from a map"
  def update(map) do
    with new_conf <- Map.merge(all(), map),
         :ok <- :persistent_term.put(@key, new_conf),
         {:ok, json} <- Jason.encode(new_conf),
         :ok <- File.write(Path.expand(@config), json) do
      {:ok, new_conf}
    else
      other -> {:error, other}
    end
  end

  def reset do
    :persistent_term.erase(@key)

    do_all()
  end

  defp do_all do
    with {:ok, file} <- File.read(Path.expand(@config)),
         {:ok, conf} <- Jason.decode(file, keys: :atoms) do
      unless :persistent_term.get(@key, nil), do: :persistent_term.put(@key, conf)

      conf
    else
      _ -> %{}
    end
  end
end
