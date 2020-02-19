defmodule TefterCli.Views.Bookmarks do
  @moduledoc """
  View module for the bookmarks resource
  """

  import Ratatouille.View
  import Ratatouille.Constants, only: [color: 1, attribute: 1]
  import TefterCli.Views.Helpers.Text, only: [truncate: 2, highlight: 2]

  alias TefterCli.Views.Bookmarks.State
  alias TefterCli.Views.Components.{TopBar, BottomBar, InfoPanel, Pagination}

  @style_header [
    attributes: [attribute(:bold)]
  ]

  @style_selected [
    color: color(:white),
    background: color(:magenta)
  ]

  @min_offset_y 5

  def init(%{bookmarks: %{resources: nil}} = state),
    do: put_in(state[:tab], :bookmarks) |> State.fetch_bookmarks()

  def init(state), do: put_in(state[:tab], :bookmarks)

  def render(%{tab: :bookmarks, bookmarks: %{resources: _bookmarks, cursor: _cursor}} = state) do
    filtered_state = put_in(state, [:bookmarks, :resources], State.filtered_bookmarks(state))

    view bottom_bar: BottomBar.render(state) do
      if state[:overlay] do
        modal(state[:overlay])
      else
        content(filtered_state)
      end
    end
  end

  def update(state, msg), do: TefterCli.Views.Bookmarks.State.update(state, msg)

  def handle_command(s), do: State.handle_command(s)

  def run_command(s), do: State.run_command(s)

  defp render_bookmark(
         %{bookmarks: %{cursor: cursor, resources: bookmarks}} = state,
         {%{title: title, url: url} = bookmark, _i}
       ) do
    table_row(if Enum.at(bookmarks, cursor) == bookmark, do: @style_selected, else: []) do
      case state[:cmd] do
        "/" <> filter ->
          table_cell(content: title |> truncate(70) |> highlight(filter))

        _ ->
          table_cell(content: title |> truncate(70))
      end

      table_cell(content: url, color: color(:blue))
    end
  end

  defp content(%{bookmarks: %{resources: bookmarks, cursor: cursor}} = state) do
    cmd = state[:cmd]

    panel title: TopBar.title(), height: :fill do
      current_bookmark_panel(state)

      panel title: "Bookmarks",
            height: Pagination.page_size() + @min_offset_y,
            color: color(:green) do
        viewport(offset_y: 0) do
          table do
            table_row(@style_header) do
              table_cell(content: "Title")
              table_cell(content: "URL")
            end

            case bookmarks do
              nil ->
                table_row do
                  table_cell(content: "Loading..")
                  table_cell(content: "")
                end

              [_ | _] ->
                for a <- Enum.with_index(Pagination.page_slice(state.bookmarks.resources, cursor)) do
                  render_bookmark(state, a)
                end

              [] when is_nil(cmd) ->
                table_row do
                  table_cell(content: "You haven't added any bookmarks")
                  table_cell(content: "")
                end

              [] ->
                table_row do
                  table_cell(content: "")
                  table_cell(content: "")
                end
            end
          end
        end
      end

      InfoPanel.render(%{type: :bookmarks}, state)
    end
  end

  defp current_bookmark_panel(%{bookmarks: %{resources: b}}) when b in [nil, []] do
    row do
      column(size: 2) do
        label do
          text(content: "")
        end
      end
    end
  end

  defp current_bookmark_panel(%{bookmarks: %{resources: bookmarks, cursor: cursor}}) do
    bookmark = Enum.at(bookmarks, cursor)

    row do
      column(size: 8) do
        panel title: "URL" do
          label do
            text(content: bookmark[:url])
          end
        end
      end

      if length(bookmark[:tags] || []) > 0 do
        column(size: 4) do
          panel title: "Tags" do
            label do
              text(content: bookmark[:tags] |> Enum.join(", ") |> truncate(40))
            end
          end
        end
      end
    end
  end

  defp modal({:show_bookmark, %{title: title, tags: tags, lists: lists, notes: notes}}) do
    overlay do
      panel title: "Title" do
        label do
          text(content: title)
        end
      end

      if length(tags) > 0 do
        panel title: "Tags" do
          label do
            text(content: tags |> Enum.join(", "))
          end
        end
      end

      if length(lists) > 0 do
        panel title: "Lists" do
          label do
            text(content: lists |> Enum.join(", "))
          end
        end
      end

      panel title: "Notes", height: 10 do
        label do
          text(content: notes)
        end
      end
    end
  end

  defp modal(_) do
    # Show an empty modal in case of bad data
    overlay do
    end
  end
end
