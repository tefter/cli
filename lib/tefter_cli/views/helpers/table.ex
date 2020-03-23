defmodule TefterCli.Views.Helpers.Table do
  import TefterCli.Views.Components.Colorscheme, only: [color_for: 1]

  def styles(key) do
    styles[key]
  end

  defp styles do
    %{
      row: [
        color: color_for([:tables, :color]),
        background: color_for([:tables, :background])
      ],
      selected: [
        color: color_for([:tables, :selected, :color]),
        background: color_for([:tables, :selected, :background])
      ]
    }
  end
end
