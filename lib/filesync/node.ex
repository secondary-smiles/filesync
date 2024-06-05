defmodule Filesync.Node do
  use GenServer

  @doc """
  Start the `Filesync.Node` `GenServer`.
  """
  def start_link(remote_host, cookie) do
    GenServer.start_link(__MODULE__, {remote_host, cookie}, name: __MODULE__)
  end

  @impl true
  def init({remote_host, cookie}) do
    Node.set_cookie(cookie)

    unless Node.connect(remote_host) == true do
      raise "Unable to connect to '#{remote_host}'."
    end

    Node.monitor(remote_host, true)

    listener = Node.spawn_link(remote_host, fn -> Filesync.Receiver.listen() end)
    {:ok, local_listener} = Task.start_link(fn -> Filesync.Receiver.listen() end)

    {:ok, {local_listener, listener}}
  end

  @impl true
  def handle_call(:dump, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:check_files, files}, {local, remote} = state) do
    send(remote, {:check_files, local, files})
    {:noreply, state}
  end

  def handle_cast(msg, {local, remote} = state) do
    send(remote, {msg, local})
    {:noreply, state}
  end

  @impl true
  def handle_info({:nodedown, node}, state) do
    {:stop, "Remote host '#{node}' disconnected.", state}
  end
end
