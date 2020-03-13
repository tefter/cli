defmodule TefterCli.Views.Aliases.State do
  alias Ratatouille.Runtime.Command
  alias TefterCli.Views.Components.Cursor
  alias TefterCli.Views.Aliases.Actions

  import Ratatouille.Constants, only: [key: 1]

  @refresh key(:ctrl_r)

  def init(%{aliases: %{resources: nil}} = state) do
    put_in(state[:tab], :aliases) |> fetch_aliases
  end

  def init(state), do: put_in(state[:tab], :aliases)

  def update(%{aliases: %{cursor: _, resources: _}} = state, msg) do
    case msg do
      {:event, %{key: @refresh}} ->
        state
        |> put_in([:aliases, :resources], nil)
        |> fetch_aliases(%{force: true})

      {:aliases_fetched, state} ->
        state

      msg ->
        case state |> TefterCli.Command.handle(msg) do
          {state, %Command{} = command} ->
            {Cursor.update(state, msg, %{type: :aliases}), command}

          state ->
            Cursor.update(state, msg, %{type: :aliases})
        end
    end
  end

  defp fetch_aliases(state), do: fetch_aliases(state, %{force: false})

  defp fetch_aliases(state, %{force: force}) do
    {state,
     Command.new(
       fn ->
         aliases = TefterCli.Aliases.fetch(%{force: force})

         state |> put_in([:aliases, :resources], Enum.reverse(aliases))
       end,
       :aliases_fetched
     )}
  end

  def handle_command(%{cmd: "/" <> _} = state) do
    apply_filters(state)
  end

  def handle_command(state), do: state

  def run_command(%{cmd: ":c " <> input} = state) do
    case Actions.create(input) do
      {:ok, _alias} ->
        state
        |> put_in([:cmd], nil)
        |> fetch_aliases(%{force: true})

      _ ->
        state
    end
  end

  def run_command(%{cmd: ":e", aliases: %{resources: aliases, cursor: cursor}} = state) do
    with %{slug: id} <- Enum.at(aliases, cursor) do
      TefterCli.System.open(%{path: "aliases/#{id}/edit"})
    else
      _ -> state
    end

    state |> put_in([:cmd], nil)
  end

  def run_command(
        %{cmd: ":d" <> _, aliases: %{resources: [_ | _] = aliases, cursor: cursor}} = state
      ) do
    with %{slug: id} <- Enum.at(aliases, cursor),
         {:ok, _} <- Actions.delete(id) do
      state
      |> put_in([:cmd], nil)
      |> fetch_aliases(%{force: true})
    else
      _ -> state
    end
  end

  def run_command(%{cmd: ":" <> _} = state), do: put_in(state[:cmd], nil)
  def run_command(state), do: handle_enter(state)

  def handle_enter(%{aliases: %{cursor: cursor, resources: [_ | _]}} = state) do
    resources = if TefterCli.Command.filter?(state), do: :filtered, else: :resources

    TefterCli.System.open(Enum.at(state[:aliases][resources], cursor))

    state
  end

  def filtered_aliases(%{aliases: %{resources: aliases}, cmd: filter}) when filter in [nil, "/"],
    do: aliases

  def filtered_aliases(%{aliases: %{resources: aliases}, cmd: "/" <> filter}) do
    regex = ~r/#{Regex.escape(filter)}/imu

    Enum.filter(aliases, fn %{name: name} ->
      String.match?(name, regex)
    end)
  end

  def filtered_aliases(%{aliases: %{resources: aliases}}), do: aliases

  defp apply_filters(state), do: put_in(state, [:aliases, :filtered], filtered_aliases(state))
end
