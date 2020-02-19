defmodule TefterCli.Views.Helpers.Text do
  @underline <<818::utf8>>

  def truncate(text, size) do
    if String.length(text) > size do
      "#{String.slice(text, 0..size)}…"
    else
      text
    end
  end

  def highlight(text, nil), do: text
  def highlight(text, ""), do: text
  def highlight(text, pattern), do: Regex.replace(~r/#{pattern}/imu, text, &"[#{&1}]")

  def underline(text) do
    for c <- String.codepoints(text), into: "", do: "#{c}#{@underline}"
  end
end
