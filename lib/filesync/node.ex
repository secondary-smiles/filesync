defmodule Filesync.Node do
  use GenServer

  @doc """
  Start the `Filesync.Node` `GenServer`.
  """
  def start_link(remote_host, cookie) do
    GenServer.start_link(__MODULE__, {remote_host, cookie}, name: __MODULE__)
  end

  @impl true
  def init({remote_host, cookie} = state) do
    Node.set_cookie(cookie)

    unless Node.connect(remote_host) == true do
      raise "Unable to connect to '#{remote_host}'."
    end

    Node.monitor(remote_host, true)

    {:ok, state}
  end

  @impl true
  def handle_call(:dump, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info({:nodedown, node}, state) do
    {:stop, "Remote host '#{node}' disconnected.", state}
  end
end
