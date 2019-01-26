defmodule EarmarkTagCloud.Mixfile do
  use Mix.Project

  def project do
    [app: :earmark_tag_cloud,
     version: "0.1.1",
     elixir: "~> 1.8",
     elixirc_paths: elixirc_paths(Mix.env),
     description: description(),
     escript: escript_config(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
       coveralls: :test,
       "coveralls.detail": :test,
       "coveralls.post": :test,
       "coveralls.html": :test
     ],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:earmark, "~> 1.3"},
      {:extractly, "~> 0.1", only: :dev},
      {:excoveralls, "~> 0.10.3", only: :test},
      # {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp description do
    """
    EarmarkTagCloud is a plugin for Earmark allowing for simple Tag Cloud generation.
    """
  end
  defp elixirc_paths(:dev), do: ["lib", "test/support", "examples"]
  defp elixirc_paths(:test), do: ["lib", "test/support", "examples"]
  defp elixirc_paths(_),     do: ["lib"]

  defp escript_config do
    [ main_module: EarmarkTagCloud.CLI ]
  end

  defp package do
    [
      files:       [ "lib", "mix.exs", "README.md", "LICENSE" ],
      maintainers: [
        "Robert Dober <robert.dober@gmail.com>",
      ],
      licenses:    [ "Apache 2 (see the file LICENSE for details)" ],
      links:       %{
        "GitHub" => "https://github.com/RobertDober/earmark_tag_cloud",
      }
    ]
  end
end
