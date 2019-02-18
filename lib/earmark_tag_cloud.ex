defmodule EarmarkTagCloud do

  @moduledoc """
    An [Earmark](https://github.com/pragdave/earmark) Plugin to easily create tag clouds inside Markdown Documents.

    In its default configuration it translates a list of lines containing keywords with three metric values to html, here
    is a simple example

    If the plugin lines are

        $$ ruby 10 100 4
        $$ elixir 40 800 12

    Earmark would pass in these lines as the `doc` array in the following doctest

        iex> doc = [
        ...> { "ruby 10 100 4", 1},
        ...> { "elixir 40 800 12", 2},
        ...> ]
        ...> EarmarkTagCloud.as_html(doc)
        {[ "<div class=\\"earmark-tag-cloud\\">\\n",
           "  <span style=\\"color: #d4d4d4; font-size: 10pt; font-weight: 100;\\">ruby</span>\\n",
           "  <span style=\\"color: #000000; font-size: 40pt; font-weight: 800;\\">elixir</span>\\n",
           "</div>\\n"
        ], []}


    As we can see from the example above the three numeric values above are specifiying

    * font size in pts

    * font weight

    * scale or color 
      Either a scale value between 0 (white) and 12 (black) that matches to 13 gamma corrected
      shades of the color.
      Or a specific color value expressed in CSS format that is # followed by six hex digits, e.g. #ff0000 for red
      One can change the settings to more grades, even 50, if you want, by means of parameters,
      c.f. Parameterization for the details


    We can also set parameters like the font-family, or the div-classes

        iex> doc = [
        ...> { "set font-family Times", 1},
        ...> { "set div-classes my-tags", 2},
        ...> { "ruby 10 100 4", 3},
        ...> { "elixir 40 800 12", 4},
        ...> ]
        ...> EarmarkTagCloud.as_html(doc)
        {[ "<div class=\\"my-tags\\" style=\\"font-family: Times;\\">\\n",
           "  <span style=\\"color: #d4d4d4; font-size: 10pt; font-weight: 100;\\">ruby</span>\\n",
           "  <span style=\\"color: #000000; font-size: 40pt; font-weight: 800;\\">elixir</span>\\n",
           "</div>\\n"
        ], []}

    Here is a different example, better suited to the corresponding languages

        iex> doc = [
        ...> { "set font-family Times", 1},
        ...> { "set div-classes my-tags", 2},
        ...> { "ruby 10 100 #d40000", 3},
        ...> { "elixir 40 800 #0000ff", 4},
        ...> ]
        ...> EarmarkTagCloud.as_html(doc)
        {[ "<div class=\\"my-tags\\" style=\\"font-family: Times;\\">\\n",
           "  <span style=\\"color: #d40000; font-size: 10pt; font-weight: 100;\\">ruby</span>\\n",
           "  <span style=\\"color: #0000ff; font-size: 40pt; font-weight: 800;\\">elixir</span>\\n",
           "</div>\\n"
        ], []}
  """
  def as_html(lines) do
    lines
    |> Enum.map(&EarmarkTagCloud.Parser.parse_line/1)
    |> EarmarkTagCloud.Renderer.render() end 
  @doc """
  This is exposed to be used without Elixir, e.g. in a Phoenix App Template


        iex(1)> EarmarkTagCloud.one_tag("elixir 40 800 12")
        {:ok, "  <span style=\\"color: #000000; font-size: 40pt; font-weight: 800;\\">elixir</span>\\n"}

  In these cases overriding the generated tag (`span` might be useful)

        iex(2)> EarmarkTagCloud.one_tag("Erlang 20 600 #0000aa", tag: "p")
        {:ok, "  <p style=\\"color: #0000aa; font-size: 20pt; font-weight: 600;\\">Erlang</p>\\n"}

  """
  def one_tag(tag_spec, options \\ []) do
    case EarmarkTagCloud.Parser.parse_line({tag_spec, 0}) do
      {:tag, _, _, _} = parsed -> _one_tag(parsed, options)
      _                        -> {:error, "Only tags allowed, no set directive"}
    end
  end

  defp _one_tag(parsed, options) do
    case EarmarkTagCloud.Renderer.render([parsed], options) do
      { output, [] } -> {:ok, Enum.at(output, -2)}
      { _, errors }  -> {:error, errors}
    end
  end
end
