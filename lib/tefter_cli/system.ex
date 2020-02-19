defmodule TefterCli.System do
  @moduledoc """
  Utility functions to interact with the OS
  """

  def open(%{"url" => url}), do: open_url(url)
  def open(%{"path" => path}), do: open("#{Tefter.base_url()}/#{path}")
  def open(path) when is_bitstring(path), do: open_url(path)
  def open(_), do: :ok

  defp open_cmd do
    case :os.type() do
      {:unix, :linux} -> "xdg-open"
      {:unix, :darwin} -> "open"
      _ -> "start"
    end
  end

  defp open_url(url), do: Porcelain.spawn_shell("#{open_cmd()} #{url} 2>/dev/null &")
end
