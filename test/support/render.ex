defmodule Support.Render do
  def render_lines(lines, lnb \\ 1), do: lines |> prepare_lines(lnb) |> EarmarkTagCloud.as_html()
  def prepare_lines(lines, lnb \\ 1), do: Enum.zip(lines, (lnb..lnb+Enum.count(lines)))
end
