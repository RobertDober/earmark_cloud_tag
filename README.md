# EarmarkTagCloud


<!-- moduledoc: EarmarkTagCloud -->
  An [Earmark](https://github.com/pragdave/earmark) Plugin to easily create tag clouds inside Markdown Documents.


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
