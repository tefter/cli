defmodule TefterCli.Views.Aliases do
  @moduledoc """
  View module for the aliases resources
  """

  import Ratatouille.View
  import Ratatouille.Constants, only: [color: 1, attribute: 1]
  import TefterCli.Views.Helpers.Text, only: [highlight: 2]
  import TefterCli.Views.Helpers.Table, only: [styles: 1]
  import TefterCli.Views.Components.Colorscheme, only: [color_for: 1]

  alias TefterCli.Views.Aliases.State
  alias TefterCli.Views.Components.{TopBar, BottomBar, InfoPanel}

  @style_header [
    attributes: [attribute(:bold)]
  ]

  @min_offset_y 5

  def init(state), do: State.init(state)

  def update(state, msg), do: State.update(state, msg)

  def render(%{tab: :aliases, aliases: %{resources: aliases, cursor: cursor}} = state) do
    filtered_state = put_in(state, [:aliases, :resources], State.filtered_aliases(state))

    view bottom_bar: BottomBar.render(state) do
      panel title: TopBar.title(), height: :fill do
        panel title: "Aliases", height: 30, color: color(:green) do
          viewport(offset_y: offset_y(cursor)) do
            table do
              table_row(@style_header) do
                table_cell(content: "Name")
                table_cell(content: "URL")
              end

              case aliases do
                nil ->
                  table_row do
                    table_cell(content: "Loading..")
                    table_cell(content: "")
                  end

                [_ | _] ->
                  for a <- Enum.with_index(filtered_state.aliases.resources),
                      do: render_alias(state, a)

                [] ->
                  table_row do
                    table_cell(content: "You haven't created any aliases")
                    table_cell(content: "")
                  end
              end
            end
          end
        end

        InfoPanel.render(%{type: :aliases}, filtered_state)
      end
    end
  end

  def handle_command(s), do: State.handle_command(s)
  def run_command(s), do: State.run_command(s)

  defp render_alias(%{aliases: %{cursor: cursor}} = state, {%{name: name, url: url}, i}) do
    table_row(if cursor == i, do: styles(:selected), else: styles(:row)) do
      case state[:cmd] do
        "/" <> filter ->
          table_cell(content: name |> highlight(filter))

        _ ->
          table_cell(content: name)
      end

      table_cell(content: url, color: color_for([:aliases, :url]))
    end
  end

  defp offset_y(cursor) when cursor < @min_offset_y, do: 0
  defp offset_y(cursor), do: cursor - @min_offset_y
end
