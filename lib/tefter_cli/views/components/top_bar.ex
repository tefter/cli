defmodule TefterCli.Views.Components.TopBar do
  @doc "Returns the title to put in the titlebar"
  def title do
    "Tefter v#{TefterCli.version()} (ctrl-q to exit) (ctrl-h for help)"
  end
end
