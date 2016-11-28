defmodule EarmarkTagCloud.Parser do


  @set_param ~r[^\s*set\s+(\S+)(?:\s+(.*))?]
  @doc """
    Parses a line, which is either a set instruction or a tag spec:

        iex> parse_line("set font-family Helvetica sans serif")
        {:set, "font-family", "Helvetica sans serif"}

        iex> parse_line("set font-family")
        {:error, "set font-family", "missing value for variable \\"font-family\\""}

        iex> parse_line("\\\\set font-family 1 2 3")
        {:tag, "set font-family", [1, 2, 3]}

        iex> parse_line("\\\\set font-family 1 2 ")
        {:error, "\\\\set font-family 1 2 ", "missing one or more of size, weight or color at end of tag specification"}
  """
  def parse_line(line) do
    case Regex.run(@set_param, line) do
      [_, key]   -> {:error, line, "missing value for variable #{inspect key}"} 
      [_, key, value] -> {:set, key, value}
      _               -> parse_tag(line)
    end
  end

  @tag_spec ~r'''
    # Tag text
    (.+)
    # Size, Weight, Color
    \s+ (\d+) \s+ (\d+) \s+ (\d+) \s*$
  '''x
  defp parse_tag(line) do
    case Regex.run(@tag_spec, line) do
      [ _, text | ints  ] -> {:tag, Regex.replace(~r{^\\}, text, ""), int(ints)}
      _                   -> {:error, line, "missing one or more of size, weight or color at end of tag specification"}
    end
  end

  defp int(numbas) do 
    numbas |>
    Enum.map(fn str -> case Integer.parse(str) do
                        {n, _} -> n
                end end)
  end
end
