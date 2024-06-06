defmodule Filesync.Node do
  use GenServer

  @doc """
  Start the `Filesync.Node` `GenServer`.
  """
  def start_link(remote_host, cookie) do
    GenServer.start_link(__MODULE__, {remote_host, cookie}, name: __MODULE__)
  end

  @doc """
  Initiate a sync between the local and remote node for `files`.
  """
  def sync(s, files) do
    GenServer.cast(s, {:check_files, files})
  end

  def sync_file(s, file) do
    GenServer.cast(s, {:sync_file, file})
  end

  @impl true
  def init({remote_host, cookie}) do
    Node.set_cookie(cookie)

    unless Node.connect(remote_host) == true do
      raise "Unable to connect to '#{remote_host}'."
    end

    Node.monitor(remote_host, true)

    {:ok, local} = Task.start_link(fn -> Filesync.Receiver.listen() end)
    remote = Node.spawn_link(remote_host, fn -> Filesync.Receiver.listen() end)

    {:ok, {local, remote}}
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

  def handle_cast({:sync_file, file}, {local, remote} = state) do
    pid = File.open!(file)
    send(remote, {:sync_file, local, pid, file})
    {:noreply, state}
  end

  # def handle_cast(msg, {local, remote} = state) do
  #   send(remote, {msg, local})
  #   {:noreply, state}
  # end

  @impl true
  def handle_info({:nodedown, node}, state) do
    {:stop, "Remote host '#{node}' disconnected.", state}
  end
end
