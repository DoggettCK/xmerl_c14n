defmodule XmerlC14n.MixProject do
  use Mix.Project

  def project do
    [
      app: :xmerl_c14n,
      version: "0.2.0",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      name: "XmerlC14n",
      source_url: "https://github.com/DoggettCK/xmerl_c14n",
      package: package(),
      docs: docs(),
      deps: deps()
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
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.20", only: :dev},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:stream_data, "~> 0.4", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description() do
    """
    `XmerlC14n` canonicalizes XML for signing.
    """
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Chris Doggett"],
      licenses: ["BSD-2-Clause"],
      links: %{"GitHub" => "https://github.com/DoggettCK/xmerl_c14n"}
    ]
  end

  defp docs() do
    [
      main: "XmerlC14n",
      source_url: "https://github.com/DoggettCK/xmerl_c14n"
    ]
  end
end
