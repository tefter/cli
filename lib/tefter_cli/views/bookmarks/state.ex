defmodule TefterCli.Views.Bookmarks.State do
  alias Ratatouille.Runtime.Command
  alias TefterCli.Views.Components.Cursor
  alias TefterCli.Views.Bookmarks.Actions

  import Ratatouille.Constants, only: [key: 1]

  @refresh key(:ctrl_r)

  def update(%{bookmarks: %{cursor: _, resources: _bookmarks}} = state, msg) do
    case msg do
      {:event, %{key: @refresh}} ->
        state
        |> put_in([:bookmarks, :resources], nil)
        |> fetch_bookmarks(%{force: true})

      {:bookmarks_fetched, state} ->
        state

      msg ->
        case state |> TefterCli.Command.handle(msg) do
          {state, %Command{} = command} ->
            {Cursor.update(state, msg, %{type: :bookmarks}), command}

          state ->
            Cursor.update(state, msg, %{type: :bookmarks})
        end
    end
  end

  def filtered_bookmarks(%{bookmarks: %{resources: bookmarks}, cmd: filter})
      when filter in [nil, "/"],
      do: bookmarks

  def filtered_bookmarks(%{bookmarks: %{resources: bookmarks}, cmd: "/" <> filter}) do
    regex = ~r/#{Regex.escape(filter)}/imu

    Enum.filter(bookmarks, fn %{title: title} ->
      String.match?(title, regex)
    end)
  end

  def filtered_bookmarks(%{bookmarks: %{resources: bookmarks}}), do: bookmarks

  def fetch_bookmarks(state), do: fetch_bookmarks(state, %{force: false})

  def fetch_bookmarks(state, %{force: force}) do
    {state,
     Command.new(
       fn ->
         bookmarks = TefterCli.Bookmarks.fetch(%{force: force})

         state
         |> put_in([:bookmarks, :resources], Enum.reverse(bookmarks))
       end,
       :bookmarks_fetched
     )}
  end

  def handle_command(%{cmd: "/" <> _} = state) do
    apply_filters(state)
  end

  def handle_command(state), do: state

  def handle_enter(%{cmd: ":" <> _} = state) do
    run_command(state)
  end

  def handle_enter(%{bookmarks: %{cursor: cursor, resources: [_ | _]}} = state) do
    resources = if TefterCli.Command.filter?(state), do: :filtered, else: :resources

    TefterCli.System.open(Enum.at(state[:bookmarks][resources], cursor)[:url])

    state
  end

  def run_command(%{cmd: ":d" <> _, bookmarks: %{resources: bookmarks, cursor: cursor}} = state) do
    with %{id: id} <- Enum.at(bookmarks, cursor),
         {:ok, updated_bookmarks} <- Actions.delete(id) do
      state
      |> put_in([:cmd], nil)
      |> put_in([:bookmarks, :resources], updated_bookmarks)
    else
      _ -> state
    end
  end

  def run_command(%{cmd: ":e", bookmarks: %{resources: bookmarks, cursor: cursor}} = state) do
    with %{id: id} <- Enum.at(bookmarks, cursor) do
      TefterCli.System.open(%{path: "bookmarks/#{id}/edit"})
    else
      _ -> state
    end

    state |> put_in([:cmd], nil)
  end

  def run_command(%{cmd: ":c " <> url} = state) do
    case Actions.create(url) do
      {:ok, _bookmark} ->
        state
        |> put_in([:cmd], nil)
        |> fetch_bookmarks(%{force: true})

      _ ->
        state
    end
  end

  def run_command(%{cmd: ":s", bookmarks: %{resources: bookmarks, cursor: cursor}} = state) do
    bookmark = Enum.at(bookmarks, cursor)

    put_in(state[:overlay], {:show_bookmark, bookmark})
  end

  def run_command(%{cmd: ":" <> _} = state), do: put_in(state[:cmd], nil)
  def run_command(state), do: handle_enter(state)

  defp apply_filters(state), do: put_in(state, [:bookmarks, :filtered], filtered_bookmarks(state))
end
