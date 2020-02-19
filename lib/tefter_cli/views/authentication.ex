defmodule TefterCli.Views.Authentication do
  @moduledoc """
  View module for the authorisation screen displayed during the first run
  until an authorisation token is obtained.
  """

  import Ratatouille.View
  import Ratatouille.Constants, only: [color: 1]

  alias TefterCli.Views.Components.{TopBar, BottomBar}

  def render(state) do
    view bottom_bar: BottomBar.render(state) do
      panel title: TopBar.title(), height: :fill do
        panel title: "Authentication", height: 30, color: color(:green) do
          row do
            column(size: 10) do
              panel do
                label do
                  text(content: "Authenticating..")
                end
              end

              panel do
                label do
                  text(content: authentication_message())
                end

                label do
                  text(content: TefterCli.Authentication.auth_url())
                end
              end
            end
          end
        end
      end
    end
  end

  defp authentication_message do
    "If a browser window does not open automatically, open it by clicking on the link:"
  end
end
