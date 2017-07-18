defmodule SimpleBayes.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :simple_bayes,
      version:         "0.12.0",
      elixir:          "~> 1.3",
      name:            "Simple Bayes",
      package:         package(),
      description:     "A Simple Bayes (a.k.a. Naive Bayes) implementation in Elixir.",
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps:            deps(),
      aliases:         ["publish": ["hex.publish", &git_tag/1]]
   ]
  end

  def application do
    [applications: [:logger, :math, :decimal]]
  end

  defp deps do
    [
      {:ex_doc,  ">= 0.0.0", only: :dev},
      {:faker,   ">= 0.0.0", only: :test},
      {:stemmer, "~> 1.0.0", only: :test},
      {:math,    ">= 0.0.0"},
      {:decimal, ">= 0.0.0"},
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
