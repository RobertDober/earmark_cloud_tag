defmodule EarmarkTagCloud.Renderer do

  import EarmarkTagCloud.GammaCorrection

  def render(parsed_lines, options \\ []) do 
  tag = Keyword.get(options, :tag, "span")
  settings = Map.put(default_values(), "tag", tag) 

  parsed_lines
  |> Enum.reduce({[], settings}, &remove_and_calc_settings/2)
  |> format_lines({["</div>\n"], []})
  end

  defp default_values, do: %{
    "scales"      => 12,
    "gamma"       => 2.2,
    "div-classes" => "earmark-tag-cloud",
    "font-family" => nil,
  }

  defp div_id(map)
  defp div_id(%{"div-id" => div_id}), do: ~s(id="#{div_id}" )
  defp div_id(_), do: ""

  defp div_line(settings) do
    case settings["font-family"] do
      nil -> ~s(<div #{div_id(settings)}class="#{settings["div-classes"]}">\n)
      font_family -> ~s(<div #{div_id(settings)}class="#{settings["div-classes"]}" style="font-family: #{font_family};">\n)
    end
  end

  defp format_lines({[],settings},{output_lines, errors}), do: { [div_line(settings)|output_lines], errors }
  defp format_lines({[{:tag, text, params, lnb} | rest], settings}, {output, errors}) do 
  case make_tag(text, params, settings) do
    {:error, _, msg} -> format_lines({rest, settings}, {output, [{:error, lnb, "#{msg}\n--> #{Enum.join([text|params], " ")}"} |errors]})
    {:ok, span}      -> format_lines({rest, settings}, {[span|output], errors})
  end
  end
  defp format_lines({[err|rest], settings}, {output, errors}) do
    format_lines({rest, settings}, {output, [err|errors]})
  end

  defp make_tag(text, params, settings)
  defp make_tag(text, [size, weight, color], settings) when is_binary(color) do
    tag = Map.get(settings, "tag")
    {:ok, ~s[  <#{tag} style="color: ##{color}; font-size: #{size}pt; font-weight: #{weight};">#{text}</#{tag}>\n]}
  end
  defp make_tag(text, [size, weight, scale], settings) do
    tag = Map.get(settings, "tag")
    case make_gray(scale, settings) do
      {:error, message} -> {:error, text, message}
      {:ok, gray}       -> {:ok, ~s[  <#{tag} style="color: ##{gray}; font-size: #{size}pt; font-weight: #{weight};">#{text}</#{tag}>\n]}
    end
  end

  defp remove_and_calc_settings({:set, key, value}, {output, settings}) do
    {output, Map.put(settings, key, value)}
  end 
  defp remove_and_calc_settings({:tag, _, _, _} = tag , {output, settings}) do
    # {make_tag(text, values, settings), settings}
    {[tag | output], settings}
  end
  defp remove_and_calc_settings(error, {output, settings}) do
    {[error | output], settings}
  end
end
