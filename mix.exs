defmodule Mate.Mixfile do
  use Mix.Project

  def project do
    [app: :mate,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Mate, []},
     applications: [:phoenix, :cowboy, :logger, :phoenix_html,  :gettext,
                    :phoenix_ecto, :postgrex, :bcrypt]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.1.1"},
     {:phoenix_ecto, "~> 2.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.3"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:bcrypt, github: "chef/erlang-bcrypt"},
		 {:exrm, "~> 0.19"},
     {:uuid, github: "okeuday/uuid"},
     {:mailman, "~> 0.1.0"},
     {:eiconv, github: "zotonic/eiconv"},
     {:joken, "~> 1.0.0"},
     {:riakc_common, github: "riakc/riakc_common"},
     {:riakc_phoenix, github: "riakc/riakc_phoenix"}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
