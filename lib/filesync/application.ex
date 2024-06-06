defmodule Filesync.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    location = System.get_env("FILESYNC_LOCATION")
    local = String.to_atom(System.get_env("FILESYNC_LOCAL"))

    File.cd!(location)
    Node.start(local)

    children = [
      # Starts a worker by calling: Filesync.Worker.start_link(arg)
      # {Filesync.Worker, arg}
      {Filesync.Watcher, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Filesync.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
