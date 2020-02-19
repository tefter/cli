defmodule Tefter.BaseUrlMiddleware do
  def call(env, next, fun) do
    Tesla.Middleware.BaseUrl.call(env, next, fun.())
  end
end
