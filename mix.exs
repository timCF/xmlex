defmodule Xmlex.Mixfile do
  use Mix.Project

  def project do
    [app: :xmlex,
     version: "0.0.1",
     elixir: "~> 1.0.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications:  [
                      :logger,
                      :hashex,
                      :extask,
                      :xmerl
                    ],
     mod: {Xmlex, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:hashex, github: "timCF/hashex"},
      {:extask, github: "timCF/extask"}
    ]
  end
end
