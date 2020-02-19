defmodule TefterCli.Views.Search.State do
  @moduledoc """
  State management module for search
  """

  import Ratatouille.Constants, only: [key: 1]
  alias Ratatouille.Runtime.Command

  @enter [key(:enter), key(:mouse_left)]
  @space key(:space)
  @delete_keys [
    key(:delete),
    key(:backspace),
    key(:backspace2)
  ]
  @up [key(:arrow_up), key(:mouse_wheel_up), key(:ctrl_k), key(:ctrl_p)]
  @down [key(:arrow_down), key(:mouse_wheel_down), key(:ctrl_j), key(:ctrl_n)]
  @debug key(:ctrl_y)
  @ctrl_u key(:ctrl_u)

  def update(%{query: query, search: %{cursor: cursor, resources: results}} = state, msg) do
    case msg do
      {:event, %{key: @debug}} ->
        raise "Get me out of here"

      {:event, %{key: k}} when k in @enter ->
        TefterCli.System.open(Enum.at(results, cursor))
        state

      {:event, %{key: @ctrl_u}} ->
        state
        |> put_in([:query], "")
        |> put_in([:search, :resources], [])

      {:event, %{key: key}} when key in @delete_keys ->
        put_in(state[:query], String.slice(query, 0..-2))
        |> search

      {:event, %{key: @space}} ->
        put_in(state[:query], query <> " ")
        |> search

      {:event, %{key: k}} when k in @up and cursor > 0 ->
        put_in(state, [:search, :cursor], cursor - 1)

      {:event, %{key: k}} when k in @up ->
        put_in(state, [:search, :cursor], length(results) - 1)

      {:event, %{key: k}} when k in @down and cursor < length(results) - 1 ->
        put_in(state, [:search, :cursor], cursor + 1)

      {:event, %{key: k}} when k in @down ->
        put_in(state, [:search, :cursor], 0)

      {:event, %{ch: ch}} when ch > 0 ->
        put_in(state[:query], query <> <<ch::utf8>>)
        |> search

      {:search_completed, state} ->
        put_in(state[:query], query)

      _ ->
        state
    end
  end

  def handle_command(state), do: state

  defp format_search(state, suggestions) do
    new_state =
      put_in(
        state,
        [:search, :resources],
        suggestions
        |> Enum.map(& &1["suggestions"])
        |> List.flatten()
        |> Enum.take(8)
      )

    new_state
  end

  defp search(%{query: query} = state) do
    {state,
     Command.new(
       fn ->
         case Tefter.suggestions(%{query: query}) do
           {:ok, %{body: %{"suggestions" => s}}} -> format_search(state, s)
           _ -> state
         end
       end,
       :search_completed
     )}
  end
end
