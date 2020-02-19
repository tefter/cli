defmodule Tefter do
  @moduledoc """
  API client for Tefter
  See: https://tefter.io/docs/api
  """

  use Tesla

  alias TefterCli.Authentication

  plug(Tefter.BaseUrlMiddleware, &base_url/0)
  plug(Tesla.Middleware.Headers, [{"accept", "application/json"}])
  plug(Tefter.TefterAuthenticationMiddleware, &Authentication.token/0)
  plug(Tesla.Middleware.JSON)

  def suggestions(%{query: prefix}) do
    get("/suggestions", query: %{prefix: prefix})
  end

  def aliases do
    get("/aliases")
  end

  def create_bookmark(%{url: url}) do
    post("/api/bookmarks", %{url: url})
  end

  def delete_bookmark(%{id: id}) do
    delete("/bookmarks/#{id}")
  end

  def bookmarks do
    get("/bookmarks")
  end

  def bookmarks_export do
    get("/export/bookmarks")
  end

  def create_alias(%{url: url, alias: alias}) do
    post("/aliases/create_from_extension", %{url: url, name: alias})
  end

  def delete_alias(%{id: id}) do
    delete("/aliases/#{id}")
  end

  def base_url, do: "https://tefter.io"
end
