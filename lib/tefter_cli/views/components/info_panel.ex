defmodule TefterCli.Views.Components.InfoPanel do
  @moduledoc """
  Re-usable component for tabular views.
  It displays commands and pagination info.
  """

  import Ratatouille.View
  import Ratatouille.Constants, only: [color: 1]

  alias TefterCli.Views.Components.Pagination

  def render(%{type: type}, state) do
    cmd = state[:cmd]

    row do
      column(size: 9) do
        if state[:cmd] do
          panel title: "Command", color: color(:yellow) do
            label do
              text(content: cmd)
            end
          end
        else
          label do
            text(content: "")
          end
        end
      end

      column(size: 3) do
        panel title: "Info" do
          label do
            text(content: pagination_label(type, state))
          end
        end
      end
    end
  end

  defp pagination_label(type, state) do
    case state[type] do
      %{resources: r} when r in [nil, []] ->
        ""

      %{resources: resources, cursor: cursor} ->
        "Page: #{Pagination.page(resources, cursor) + 1} / #{Pagination.total_pages(resources)} Total: #{
          length(resources)
        }"

      _ ->
        ""
    end
  end
end
