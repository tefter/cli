defmodule Tefter.TefterAuthenticationMiddleware do
  @auth_header "X-User-Token"

  def call(env, next, fun) do
    env
    |> Tesla.put_header(@auth_header, fun.())
    |> Tesla.run(next)
  end
end
