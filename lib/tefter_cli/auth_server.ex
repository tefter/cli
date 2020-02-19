defmodule TefterCli.AuthServer do
  @moduledoc """
  A simple HTTP server to receive and decode the user's authentication token.
  See `TefterCli.Authentication` for more info about the authentication strategies.
  """

  use Ace.HTTP.Service, port: 0, cleartext: true
  use Raxx.SimpleServer
  alias TefterCli.Config

  @impl Raxx.SimpleServer
  def handle_request(request, _) do
    with %{"hash" => encoded} <- get_query(request),
         {:ok, decoded} <- Base.url_decode64(encoded),
         {:ok, %{"token" => token, "username" => username}} <- Jason.decode(decoded),
         {:ok, _} <- Config.update(%{token: token, username: username}) do
      TefterCli.Authentication.stop_server()
      redirect("#{Tefter.base_url()}/integrations/auth_callbacks/cli", body: "Redirecting..")
    else
      _ ->
        response(:ok)
        |> set_header("content-type", "text/plain")
        |> set_body("Something went wrong while authenticating Tefter. Try restarting the app..")
    end
  end
end
