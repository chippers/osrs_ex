defmodule OsrsEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :osrs_ex,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      docs: [
        groups_for_modules: groups_for_modules(),
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false}
    ]
  end

  defp groups_for_modules do
    [
      "Hiscores": [
        OsrsEx.Hiscores,
        OsrsEx.Hiscores.Hiscore,
        OsrsEx.Hiscores.Skill,
        OsrsEx.Hiscores.Activity,
      ]
    ]
  end
end
