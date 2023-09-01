defmodule BonnyDispatch.MixProject do
  use Mix.Project

  def project do
    [
      app: :bonny_dispatch,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {BonnyDispatch.Application, [env: Mix.env()]}
    ]
  end

  defp deps do
    [
      {:bonny, "~> 1.0"}
    ]
  end
end
