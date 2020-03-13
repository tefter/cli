defmodule TefterCli.Command do
  @moduledoc """
  Module handling input and state management for commands.
  TefterCli's commands are Vim-inspired.

  We trigger search when the user types `/`.
  There are also some context-aware colon commands.

  For example typing `:d` and hitting enter in the Aliases tab will delete the alias
  under the cursor. It'll delete a bookmark in the Bookmarks tab.

  To achieve that we delegate a `handle_command/1` with the current state to the active
  view module. Similarly when a command has been typed and the users hits enter,
  we delegate `run_command/1` with the current state.
  """

  import Ratatouille.Constants, only: [key: 1]

  @enter [key(:enter), key(:mouse_left)]
  @space key(:space)
  @ctrl_u key(:ctrl_u)

  @delete_keys [
    key(:delete),
    key(:backspace),
    key(:backspace2)
  ]

  def handle(state, msg) do
    cmd = state[:cmd]

    case msg do
      {:event, %{key: k}} when k in @enter ->
        run_command(state)

      {:event, %{ch: ?:}} when is_nil(cmd) ->
        state
        |> put_in([:cmd], ":")

      {:event, %{ch: ?/}} when is_nil(cmd) ->
        state
        |> put_in([:cmd], "/")

      {:event, %{key: @space}} when not is_nil(cmd) ->
        put_in(state[:cmd], cmd <> " ")

      {:event, %{key: key}} when key in @delete_keys and cmd == "" ->
        put_in(state[:cmd], nil)
        |> handle_command
        |> maybe_reset_cursor

      {:event, %{key: key}} when key in @delete_keys and is_nil(cmd) ->
        state

      {:event, %{key: @ctrl_u}} when is_nil(cmd) ->
        state

      {:event, %{key: @ctrl_u}} when not is_nil(cmd) ->
        put_in(state[:cmd], "")

      {:event, %{key: key}} when key in @delete_keys ->
        if String.length(cmd) > 0 do
          put_in(state[:cmd], String.slice(state[:cmd], 0..-2))
          |> handle_command
          |> maybe_reset_cursor
        else
          state
        end

      {:event, %{ch: ch}} when ch > 0 and not is_nil(cmd) ->
        state
        |> put_in([:cmd], cmd <> <<ch::utf8>>)
        |> handle_command
        |> maybe_reset_cursor

      _ ->
        state
    end
  end

  @doc "Return true when a search command is active"
  def filter?(%{cmd: "/" <> _}), do: true
  def filter?(_), do: false

  defp run_command(%{cmd: ":h" <> _} = state) do
    state
    |> put_in([:cmd], nil)
    |> put_in([:tab], :help)
  end

  defp run_command(%{cmd: ":go " <> alias} = state) do
    TefterCli.System.open(%{path: "/go/#{alias}"})

    state
    |> put_in([:cmd], nil)
  end

  defp run_command(%{cmd: ":q" <> _}), do: TefterCli.Application.stop(:ok)
  defp run_command(%{tab: type} = state), do: TefterCli.App.view(type).run_command(state)

  defp handle_command(%{tab: type} = state), do: TefterCli.App.view(type).handle_command(state)

  defp maybe_reset_cursor(%{cmd: ":" <> _} = state), do: state
  defp maybe_reset_cursor(%{cmd: "/" <> _} = state), do: reset_cursor(state)
  defp maybe_reset_cursor(%{cmd: cmd} = state) when cmd in [nil, ""], do: reset_cursor(state)
  defp maybe_reset_cursor(state), do: state

  defp reset_cursor(%{tab: type} = state), do: put_in(state, [type, :cursor], 0)
end
