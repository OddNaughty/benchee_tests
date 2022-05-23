defmodule MyBenshee.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_benshee,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpoison, :benchee, :timex, :jason],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 1.0", only: :dev},
      {:jason, "~> 1.3"},
      {:httpoison, "~> 1.8"},
      {:timex, "~> 3.7.6"},
      {:floki, "~> 0.31.0"}
    ]
  end
end
