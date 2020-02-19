defmodule TefterCli.App.State do
  @moduledoc """
  The main state management module
  """

  require Logger
  import Ratatouille.Constants, only: [key: 1]

  alias TefterCli.Views.{Search, Bookmarks, Aliases}

  @ctrl_b key(:ctrl_b)
  @ctrl_a key(:ctrl_a)
  @ctrl_l key(:ctrl_l)
  @ctrl_s key(:ctrl_s)
  @ctrl_h key(:ctrl_h)
  @f5 key(:f5)
  @escape key(:esc)

  @initial_state %{
    query: "",
    tab: :search,
    token: nil,
    filter: nil,
    search: %{
      resources: [],
      cursor: 0
    },
    aliases: %{
      resources: nil,
      filtered: [],
      cursor: 0
    },
    bookmarks: %{
      resources: nil,
      filtered: [],
      cursor: 0
    }
  }

  def init do
    put_in(@initial_state[:token], TefterCli.Authentication.token())
  end

  def update(state, msg) do
    Logger.info(inspect(msg))

    case {state, msg} do
      {_, {:event, %{key: @escape}}} ->
        state
        |> put_in([:cmd], nil)
        |> put_in([:overlay], false)
        |> handle_command

      {%{token: nil}, :check_token} ->
        check_token(state)

      {_, {:event, %{key: @f5}}} ->
        IEx.Helpers.recompile()
        state

      {%{token: "" <> _}, {:event, %{key: @ctrl_s}}} ->
        put_in(state[:tab], :search)

      {%{token: "" <> _}, {:event, %{key: @ctrl_l}}} ->
        put_in(state[:tab], :lists)

      {%{token: "" <> _}, {:event, %{key: @ctrl_b}}} ->
        Bookmarks.init(state)

      {%{token: "" <> _}, {:event, %{key: @ctrl_h}}} ->
        put_in(state[:tab], :help)

      {%{token: "" <> _}, {:event, %{key: @ctrl_a}}} ->
        Aliases.init(state)

      {%{tab: :search}, _} ->
        Search.update(state, msg)

      {%{tab: :aliases}, _} ->
        Aliases.update(state, msg)

      {%{tab: :bookmarks}, _} ->
        Bookmarks.update(state, msg)

      _ ->
        state
    end
  end

  defp check_token(state) do
    case TefterCli.Authentication.token() do
      token when is_bitstring(token) -> put_in(state[:token], token)
      _ -> state
    end
  end

  defp handle_command(state) do
    TefterCli.App.view(state[:tab]).handle_command(state)
  end
end
