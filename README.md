# EarmarkTagCloud

<!--
DO NOT EDIT THIS FILE
It has been generated from a template by Extractly (https://github.com/RobertDober/extractly.git)
and any changes you make in this file will most likely be lost
-->

[![Hex.pm](https://img.shields.io/hexpm/v/earmark_tag_cloud.svg)](https://hex.pm/packages/earmark_tag_cloud)
[![Hex.pm](https://img.shields.io/hexpm/dw/earmark_tag_cloud.svg)](https://hex.pm/packages/earmark_tag_cloud)
[![Hex.pm](https://img.shields.io/hexpm/dt/earmark_tag_cloud.svg)](https://hex.pm/packages/earmark_tag_cloud)

## Usage without Earmark

  An [Earmark](https://github.com/pragdave/earmark) Plugin to easily create tag clouds inside Markdown Documents.

  In its default configuration it translates a list of lines containing keywords with three metric values to html, here
  is a simple example

      iex> doc = [
      ...> { "ruby 10 100 4", 1},
      ...> { "elixir 40 800 12", 2},
      ...> ]
      ...> EarmarkTagCloud.as_html(doc)
      {[ "<div class=\"earmark-tag-cloud\">\n",
         "  <span style=\"color: #d4d4d4; font-size: 10pt; font-weight: 100;\">ruby</span>\n",
         "  <span style=\"color: #000000; font-size: 40pt; font-weight: 800;\">elixir</span>\n",
         "</div>\n"
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
      {[ "<div class=\"my-tags\" style=\"font-family: Times;\">\n",
         "  <span style=\"color: #d4d4d4; font-size: 10pt; font-weight: 100;\">ruby</span>\n",
         "  <span style=\"color: #000000; font-size: 40pt; font-weight: 800;\">elixir</span>\n",
         "</div>\n"
      ], []}

  Here is a different example, better suited to the corresponding languages

      iex> doc = [
      ...> { "set font-family Times", 1},
      ...> { "set div-classes my-tags", 2},
      ...> { "ruby 10 100 #d40000", 3},
      ...> { "elixir 40 800 #0000ff", 4},
      ...> ]
      ...> EarmarkTagCloud.as_html(doc)
      {[ "<div class=\"my-tags\" style=\"font-family: Times;\">\n",
         "  <span style=\"color: #d40000; font-size: 10pt; font-weight: 100;\">ruby</span>\n",
         "  <span style=\"color: #0000ff; font-size: 40pt; font-weight: 800;\">elixir</span>\n",
         "</div>\n"
      ], []}


This is exposed to be used without Elixir, e.g. in a Phoenix App Template


      iex(1)> EarmarkTagCloud.one_tag("elixir 40 800 12")
      {:ok, "  <span style=\"color: #000000; font-size: 40pt; font-weight: 800;\">elixir</span>\n"}

In these cases overriding the generated tag (`span` might be useful)

      iex(2)> EarmarkTagCloud.one_tag("Erlang 20 600 #0000aa", tag: "p")
      {:ok, "  <p style=\"color: #0000aa; font-size: 20pt; font-weight: 600;\">Erlang</p>\n"}



## Usage with Earmark

If the plugin lines are

    $$ ruby 10 100 4
    $$ elixir 40 800 12

then call

    Earmark.as_html(lines, Earmark.Plugin.define(EarmarkTagCloud))

Please see [Earmark](https://github.com/pragdave/earmark)  for more details of how to use plugins

## COPYRIGHT & LICENSE

  Apache 2 License

  Copyright © 2016,7,8,9 RobertDober, robert.dober@gmail.com.

  See file `LICENSE` for details.

## Installation

[Available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `earmark_tag_cloud` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:earmark_tag_cloud, "~> 0.1.0"}]
    end
    ```

  2. Ensure `earmark_tag_cloud` is started before your application:

    ```elixir
    def application do
      [applications: [:earmark_tag_cloud]]
    end
    ```
