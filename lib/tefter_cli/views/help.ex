defmodule TefterCli.Views.Help do
  @moduledoc """
  View module for Help
  """

  import Ratatouille.View
  import Ratatouille.Constants, only: [color: 1, attribute: 1]

  alias TefterCli.Views.Components.{BottomBar, TopBar}

  @bold attribute(:bold)

  def render(%{help: %{cursor: cursor}} = state) do
    view bottom_bar: BottomBar.render(state) do
      viewport(offset_y: cursor) do
        panel title: TopBar.title(), height: :fill do
          row do
            column(size: 12) do
              label()

              label(
                content: "Tefter v#{TefterCli.version()}",
                attributes: [@bold],
                color: color(:magenta)
              )

              label(content: "Source / Issues: https://github.com/tefter/cli")
              label(content: "Questions:       support@tefter.io")
              label()

              label(
                content: "Use the j and k keys to scroll in help",
                attributes: [@bold],
                color: color(:magenta)
              )

              label(
                content: "Min recommended terminal dimensions:  37 x 154",
                color: color(:yellow)
              )

              label()
              label(content: "Keyboard Controls", attributes: [@bold])
              label()
              label(content: "Tabs / Panes")
              control_label("ctrl-s", "Search            (Search for bookmarks / lists / aliases)")
              control_label("ctrl-a", "Aliases           (Displays your aliases)")
              control_label("ctrl-b", "Bookmarks         (Displays your bookmarks)")
              control_label("ctrl-h", "Help              (Shows this help screen)")
              control_label("tab   ",    "Switches to the next tab")
              control_label("home  ",   "Switches to the first tab")
              label()
              label(content: "Navigation / Actions")
              control_label("UP/DOWN ctrl-j/ctrl-k or mouse wheel   ", "Scroll vertically")
              control_label("ctrl-d/ctrl-u                          ", "Scroll up / down by half a page")

              control_label(
                "enter                                  ",
                "Open a result in the browser"
              )

              control_label("ctrl-d                                 ", "Exit")
              control_label("ctrl-r                                 ", "Refresh results")
              control_label("/                                      ", "Search")
              control_label("escape                                 ", "Clear search / command")
              label()
              label(content: "General Commands")
              control_label(":h                                     ", "Shows this help screen")
              control_label(":q                                     ", "Exit")
              label()
              label(content: "Bookmark Commands")
              control_label(":c <url>                               ", "Bookmarks the given URL")
              control_label(":e                                     ", "Edits the selected bookmark")

              control_label(
                ":d                                     ",
                "Deletes the bookmark under the cursor"
              )

              control_label(
                ":s                                     ",
                "Displays info about the selected bookmark"
              )

              label()
              label(content: "Alias Commands")
              control_label(":c <alias> <url>                       ", "Creates an alias")
              control_label(":e                                     ", "Edits the selected alias")
              control_label(
                ":d                                     ",
                "Deletes the alias under the cursor"
              )
              control_label(":go <alias>                            ", "Navigates to the given alias")
            end
          end
        end
      end
    end
  end

  def update(%{help: %{cursor: cursor}} = state, msg) do
    case {state, msg} do
      {_, {:event, %{ch: ?j}}} ->
        put_in(state, [:help, :cursor], cursor + 1)

      {_, {:event, %{ch: ?k}}} when cursor > 0 ->
        put_in(state, [:help, :cursor], cursor - 1)

      _ -> state
    end
  end

  def handle_command(state), do: state

  defp control_label(keys, description) do
    label do
      text(attributes: [@bold], content: "  #{keys}")
      text(content: "   #{description}")
    end
  end
end
