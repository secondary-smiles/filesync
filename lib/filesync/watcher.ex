defmodule Filesync.Watcher do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_args) do
    {:ok, watcher_pid} = FileSystem.start_link(dirs: ["."])
    FileSystem.subscribe(watcher_pid)
    {:ok, watcher_pid}
  end

  def handle_info({:file_event, _, {path, [:modified, :closed]}}, state) do
    location = System.get_env("FILESYNC_LOCATION")
    new_path = String.replace_prefix(path, location, "")
    Filesync.Node.sync_file(Filesync.Node, new_path)
    {:noreply, state}
  end

  # def handle_info({:file_event, _, {path, [:deleted]}}, state) do
  #   IO.puts("removed: #{path}")
  #   {:noreply, state}
  # end

  def handle_info({:file_event, _, {_path, _events}}, state) do
    {:noreply, state}
  end
end
