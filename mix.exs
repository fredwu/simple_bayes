defmodule SimpleBayes.Mixfile do
  use Mix.Project

  def project do
    [
      app:               :simple_bayes,
      version:           "0.12.2",
      elixir:            "~> 1.5",
      name:              "Simple Bayes",
      package:           package(),
      description:       "A Simple Bayes (a.k.a. Naive Bayes) implementation in Elixir.",
      start_permanent:   Mix.env == :prod,
      deps:              deps(),
      test_coverage:     [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      aliases:           ["publish": ["hex.publish", &git_tag/1]],
   ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:math,        ">= 0.0.0"},
      {:decimal,     ">= 0.0.0"},
      {:ex_doc,      ">= 0.0.0", only: :dev},
      {:faker,       ">= 0.0.0", only: :test},
      {:stemmer,     "~> 1.0",   only: :test},
      {:excoveralls, "~> 0.7",   only: :test},
    ]
  end

  defp package do
    [
      maintainers: ["Fred Wu"],
      licenses:    ["MIT"],
      links:       %{"GitHub" => "https://github.com/fredwu/simple_bayes"}
    ]
  end

  defp git_tag(_args) do
    System.cmd "git", ["tag", "v" <> Mix.Project.config[:version]]
  end
end
