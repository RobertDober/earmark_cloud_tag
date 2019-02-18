defmodule EarmarkTagCloud.Parser do

   @set_param ~r[^\s*set\s+(\S+)(?:\s+(.*))?]

   @doc """
    Parses a line, which is either a set instruction or a tag spec:

        iex> parse_line({"set font-family Helvetica sans serif", 1})
        {:set, "font-family", "Helvetica sans serif"}

        iex> parse_line({"set font-family", 4})
        {:error, 4, "missing value for variable \\"font-family\\""}

        iex> parse_line({"\\\\set font-family 1 2 3", 40})
        {:tag, "set font-family", [1, 2, 3], 40}

        iex> parse_line({"\\\\set font-family 1 2 ", 42})
        {:error, 42, "missing one or more of necessary integer values (font-size font-weight gray-scale) at end of tag specifcation"}
  """
  def parse_line({line, lnb}) do
    case Regex.run(@set_param, line) do
      [_, key]   -> {:error, lnb, "missing value for variable #{inspect key}"} 
      [_, key, value] -> {:set, key, translate(key, value)}
      _               -> parse_tag({line, lnb})
    end
  end

  @tag_spec ~r'''
    # Tag text
    (.+)
    # Size, Weight, Color
    \s+ (\d+) \s+ (\d+) \s+ (\d+|\#[0-9a-fA-F]{6}) \s*$
  '''x
  defp parse_tag({line, lnb}) do
    case Regex.run(@tag_spec, line) do
      [ _, text | numbas  ] -> {:tag, Regex.replace(~r{^\\}, text, ""), ints(numbas), lnb}
      _                     -> {:error, lnb, "missing one or more of necessary integer values (font-size font-weight gray-scale) at end of tag specifcation"}
    end
  end

  defp float(numba) do
    with {parsed, _} <- Float.parse(numba), do: parsed
  end

  defp ints(numbas) do 
    numbas |> Enum.map(&int/1)
  end

  defp int(numba)
  defp int("#" <> numba), do: numba
  defp int(numba) do
    with {parsed, _} <- Integer.parse(numba), do: parsed
  end 

  defp translate(key, value) do
    case key do 
      "scales" -> int(value)
      "gamma" -> float(value)
      _       -> value
    end
  end
end
