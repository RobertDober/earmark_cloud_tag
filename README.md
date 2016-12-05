# EarmarkTagCloud


## Concerning Hex

This plugin (as all plugins) depends on `Earmark` v1.1.  Before it is released I cannot push this package to hex.

If you want to use this plugin you you can clone this repo and use the github dependency to use a bleeding edge but stable version of Earmark.
<!-- moduledoc: EarmarkTagCloud -->
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
      {[ "<div class=\"earmark-tag-cloud\" style=\"font-family: Arial;\">\n",
         "  <span style=\"color: #d4d4d4; font-size: 10pt; font-weight: 100;\">ruby</span>\n",
         "  <span style=\"color: #000000; font-size: 40pt; font-weight: 800;\">elixir</span>\n",
         "</div>\n"
      ], []}


  As we can see from the example above the three numeric values above are specifiying

  * font size in pts

  * font weight

  * and a gray scale value between 0 (white) and 12 (black) that matches to 13 gamma corrected
    shades of gray (you can change the settings to more grades, even 50, if you want.
    c.f. Parameterization)


  ## COPYRIGHT & LICENSE

  Apache 2 License

  Copyright © 2016 RobertDober, robert.dober@gmail.com.

  Copyright © 2014 Dave Thomas, The Pragmatic Programmers. (readme mix task)

  See file `LICENSE` for details.
<!-- endmoduledoc: EarmarkTagCloud -->

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
