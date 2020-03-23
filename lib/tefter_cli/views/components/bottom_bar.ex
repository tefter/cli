defmodule TefterCli.Views.Components.BottomBar do
  @moduledoc """
  Re-usable component for bottom bar display.
  Renders the available tabs, username and command status.
  """

  import Ratatouille.View
  import TefterCli.Views.Components.Colorscheme, only: [color_for: 1]

  alias TefterCli.Config

  def render(%{tab: tab} = state) do
    bar do
      label do
        for <<c>> <> rest = t <- Enum.map(TefterCli.App.tabs(), &to_string/1) do
          initial = List.to_string([c]) |> String.upcase()
          content = " [#{initial}]#{rest} "

          if to_string(tab) == t do
            text(
              background: color_for([:tabs, :selected, :background]),
              color: color_for([:tabs, :selected, :color]),
              content: content
            )
          else
            text(content: content)
          end
        end

        case Config.all()[:username] do
          u when is_bitstring(u) -> text(content: "║ User: #{u} ")
          _ -> nil
        end

        text(content: "║ Mode: ")

        case state[:cmd] do
          "" <> _ -> text(content: " COMMAND ", color: :magenta, background: :cyan)
          _ -> text(content: " NORMAL ", color: :white, background: :black)
        end
      end
    end
  end
end
