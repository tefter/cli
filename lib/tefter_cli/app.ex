defmodule TefterCli.App do
  @moduledoc """
  The main module of the application.
  It delegates rendering and state updates to a module per tab.
  """

  @behaviour Ratatouille.App

  alias Ratatouille.Runtime.{Subscription}
  alias TefterCli.App.State
  alias TefterCli.Views.{Search, Bookmarks, Lists, Aliases, Authentication, Help}

  @tabs [:search, :aliases, :bookmarks, :help]

  @impl true
  def init(_), do: State.init()

  @impl true
  def update(state, msg), do: State.update(state, msg)

  @impl true
  def render(%{token: nil} = state), do: Authentication.render(state)
  def render(%{tab: :search} = state), do: Search.render(state)
  def render(%{tab: :bookmarks} = state), do: Bookmarks.render(state)
  def render(%{tab: :aliases} = state), do: Aliases.render(state)
  def render(%{tab: :lists} = state), do: Lists.render(state)
  def render(%{tab: :help} = state), do: Help.render(state)

  @doc "Returns the available application tabs"
  def tabs, do: @tabs

  @impl true
  def subscribe(%{token: nil}), do: Subscription.interval(500, :check_token)
  def subscribe(_), do: Subscription.interval(100_000, :check_token)

  @doc "Returns the module responsible for the given tab"
  def view(type) do
    case type do
      :search -> Search
      :bookmarks -> Bookmarks
      :lists -> Lists
      :aliases -> Aliases
      :help -> Help
    end
  end
end
