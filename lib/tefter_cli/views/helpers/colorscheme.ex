defmodule TefterCli.Views.Components.Colorscheme do
  @moduledoc """
  Provides functions for a configurable colorscheme
  """

  @defaults %{
    tabs: %{
      selected: %{
        color: :black,
        background: :green
      }
    },
    aliases: %{
      url: :blue
    },
    tables: %{
      color: :white,
      background: :default,
      selected: %{
        color: :white,
        background: :magenta
      }
    }
  }

  def color_for(keys) do
    colors = Map.keys(Ratatouille.Constants.colors)
    color = case get_in(scheme(), keys) do
              nil -> get_in(@defaults, keys)
              c -> String.to_atom(c)
            end

    if color in colors, do: color, else: get_in(@defaults, keys)
  end

  defp scheme do
    case config() do
      nil -> @defaults
      m -> Map.merge(@defaults, m)
    end
  end

  defp config, do: TefterCli.Config.all()[:colorscheme]
end
