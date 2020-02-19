defmodule TefterCli.Views.Search do
  @moduledoc """
  View module for search
  """

  import Ratatouille.View
  import Ratatouille.Constants, only: [color: 1]

  alias TefterCli.Views.Search.State
  alias TefterCli.Views.Components.{TopBar, BottomBar}

  def render(state) do
    view bottom_bar: BottomBar.render(state) do
      panel title: TopBar.title(), height: :fill do
        row do
          column(size: 6) do
            panel title: "Search", color: color(:blue) do
              label(content: state[:query] <> "▌")
            end
          end

          column(size: 6) do
            panel title: "Info" do
              label do
                text(content: "Open: return. Move: ctrl-j / ctrl-k")
              end
            end
          end
        end

        panel title: "Results", height: 20, color: color(:green) do
          case state.search.resources do
            [_ | _] ->
              for r <- Enum.with_index(state.search.resources), do: render_result(state, r)

            [] ->
              label do
                text(content: "")
              end

            _ ->
              label do
                text(content: "Start typing to search.")
              end
          end
        end
      end
    end
  end

  def update(state, msg), do: State.update(state, msg)

  def handle_command(s), do: State.handle_command(s)

  defp render_result(%{search: %{cursor: cursor}}, {%{"name" => name} = result, i}) do
    row do
      column(size: 10) do
        label do
          result_cursor(cursor, i)
          result_icon(result)
          text(content: " " <> name)
        end
      end
    end
  end

  defp result_cursor(cursor, cursor), do: text(content: "▶ ", color: color(:green))
  defp result_cursor(_, _), do: text(content: "")

  defp result_icon(%{"title" => title}) do
    case {:os.type(), title} do
      {{_, :darwin}, "Domain"} -> text(content: "🌍 ")
      {{_, :darwin}, "List"} -> text(content: "📂 ")
      {{_, :darwin}, "Tag"} -> text(content: "🏷  ")
      {{_, :darwin}, "Bookmark"} -> text(content: "📘 ")
      {{_, :darwin}, "Alias"} -> text(content: "✨ ")
      {_, other} -> text(content: "[#{other}]" <> " ")
    end
  end
end
