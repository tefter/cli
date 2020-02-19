defmodule TefterCli.Views.Lists do
  @moduledoc """
  (Placeholder) View module for list resources
  """

  import Ratatouille.View

  alias TefterCli.Views.Components.{TopBar, BottomBar}
  import Ratatouille.Constants, only: [color: 1]

  def render(state) do
    view bottom_bar: BottomBar.render(state) do
      panel title: TopBar.title(), height: :fill do
        panel title: "Lists", height: 30, color: color(:green) do
          row do
            column(size: 10) do
              panel do
                label do
                  text(content: "List 1")
                end
              end
            end
          end

          row do
            column(size: 10) do
              panel do
                label do
                  text(content: "List 2")
                end
              end
            end
          end
        end
      end
    end
  end
end
