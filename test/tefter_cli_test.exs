defmodule TefterCliTest do
  use ExUnit.Case
  doctest TefterCli

  test "greets the world" do
    assert TefterCli.hello() == :world
  end
end
