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
        ...> EarmarkTagCloud.render(doc)
        {[ "<div class=\\"earmark-tag-cloud\\" style=\\"font-family: Arial;\\">",
           "  <span style=\\"color: #525252; font-size: 10pt; font-weight: 100;\\">ruby</span>",
           "  <span style=\\"color: #000000; font-size: 40pt; font-weight: 800;\\">elixir</span>",
           "</div>"
        ], []} 



    ## COPYRIGHT & LICENSE

    Apache 2 License

    Copyright © 2016 RobertDober, robert.dober@gmail.com.

    Copyright © 2014 Dave Thomas, The Pragmatic Programmers. (readme mix task)

    See file `LICENSE` for details.
  """
  def render(lines) do
    with {text_lines, lnbs} <- Enum.unzip(lines) do
      text_lines
      |> Enum.map(&EarmarkTagCloud.Parser.parse_line/1)
      |> EarmarkTagCloud.Renderer.render()
    end
  end
end
