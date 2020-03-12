defmodule TefterCli.Views.Components.Cursor do
  @moduledoc """
  State management module for tabular views.
  """

  import Ratatouille.Constants, only: [key: 1]
  alias TefterCli.Views.Components.Pagination

  @up [key(:arrow_up), key(:mouse_wheel_up), key(:ctrl_k), key(:ctrl_p)]
  @down [key(:arrow_down), key(:mouse_wheel_down), key(:ctrl_j), key(:ctrl_n)]
  @next_page [key(:ctrl_d)]
  @previous_page [key(:ctrl_u)]

  def update(state, msg, %{type: type}) do
    cursor = state[type][:cursor]
    resources_type = if TefterCli.Command.filter?(state), do: :filtered, else: :resources
    resources = state[type][resources_type]
    scroll_size = round(Pagination.page_size() / 2)
    resource_len = length(resources)

    case msg do
      _ when resources == [] ->
        state

      {:event, %{key: k}} when k in @up and cursor > 0 ->
        put_in(state, [type, :cursor], cursor - 1)

      {:event, %{key: k}} when k in @up ->
        put_in(state, [type, :cursor], resource_len - 1)

      {:event, %{key: k}} when k in @down and cursor < resource_len - 1 ->
        put_in(state, [type, :cursor], cursor + 1)

      {:event, %{key: k}} when k in @down ->
        put_in(state, [type, :cursor], 0)

      {:event, %{key: k}} when k in @next_page and cursor + scroll_size >= resource_len - 1 ->
        put_in(state, [type, :cursor], resource_len - 1)

      {:event, %{key: k}} when k in @next_page ->
        put_in(state, [type, :cursor], cursor + scroll_size)

      {:event, %{key: k}} when k in @previous_page and cursor - scroll_size >= 0 ->
        put_in(state, [type, :cursor], cursor - scroll_size)

      {:event, %{key: k}} when k in @previous_page ->
        put_in(state, [type, :cursor], 0)

      _ ->
        state
    end
  end
end
