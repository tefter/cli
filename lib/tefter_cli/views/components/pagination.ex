defmodule TefterCli.Views.Components.Pagination do
  @moduledoc """
  Utility functions for paginated resources
  """

  @page_size 20

  def page_size, do: @page_size

  def total_pages([_ | _] = resources), do: round(:math.ceil(length(resources) / @page_size))
  def total_pages(_), do: 0

  def page(_resources, cursor), do: div(cursor, @page_size)

  def page_slice(resources, cursor),
    do: Enum.slice(resources, page(resources, cursor) * @page_size, @page_size)
end
