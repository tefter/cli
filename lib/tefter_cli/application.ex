defmodule TefterCli.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Supervisor.start_link(children(), strategy: :one_for_one, name: TefterCli.Supervisor)
  end

  def stop(_) do
    System.halt()
  end

  defp children do
    [
      {
        Ratatouille.Runtime.Supervisor,
        runtime: [app: TefterCli.App, quit_events: [{:key, Ratatouille.Constants.key(:ctrl_q)}]]
      },
      %{
        id: TefterCli.Authentication,
        start: {TefterCli.Authentication, :start_link, [%{}]},
        restart: :transient
      }
    ]
  end
end
