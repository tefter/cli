defmodule TefterCli.Authentication do
  @moduledoc """
  The first time the application is started and there's no tefter config file with
  an authentication token, an HTTP server (see `TefterCli.AuthServer`) is started.

  Then we attempt to open a browser window pointing to an endpoint of Tefter which will
  redirect to a URL of the local server we started. The server will then decode the token
  and keep it in a file-backed config.
  """

  use GenServer

  alias __MODULE__, as: Self

  def start_link(default), do: GenServer.start_link(Self, default, name: Self)

  def token, do: TefterCli.Config.all()[:token]

  def stop_server, do: Process.send_after(Process.whereis(Self), :stop_server, 10_000)

  def port, do: GenServer.call(Self, :port)

  def auth_url, do: auth_url(port())

  defp auth_url(port) do
    "#{Tefter.base_url()}/integrations/auth_callbacks/cli?redir=http://localhost:#{port}/auth"
  end

  @impl true
  def init(_) do
    token = token()

    if token do
      {:ok, %{token: token}}
    else
      {:ok, server} = TefterCli.AuthServer.start_link(%{})
      {:ok, port} = Ace.HTTP.Service.port(server)

      port |> auth_url |> TefterCli.System.open()

      {:ok, %{token: nil, server: server, port: port}}
    end
  end

  @impl true
  def handle_call(:port, _from, %{port: port} = state) do
    {:reply, port, state}
  end

  @impl true
  def handle_info(:stop_server, %{server: server} = state) do
    Process.unlink(server)
    GenServer.stop(server)

    {:noreply, Map.merge(state, %{server: nil, port: nil})}
  end
end
