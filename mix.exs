Code.eval_file "tasks/readme.exs"
defmodule EarmarkTagCloud.Mixfile do
  use Mix.Project

  def project do
    [app: :earmark_tag_cloud,
     version: "0.1.0",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     description: description(),
     escript: escript_config(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:earmark, ">= 1.0.9", github: "pragdave/earmark", branch: "for_plugins"},
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
