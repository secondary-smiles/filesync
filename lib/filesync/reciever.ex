defmodule Filesync.Receiver do
  def listen() do
    receive do
      {:hello, remote} ->
        send(remote, :hi)

      {:check_files, remote, files} ->
        send(remote, {:files_check, Filesync.File.check_files(files)})

      {:sync_file, remote, name, file} ->
        send(remote, {:file_sync, Filesync.Sync.sync(name, file)})

      {:files_check, {:ok, files}} ->
        Enum.map(files, fn file ->
          Filesync.Node.sync_file(Filesync.Node, file)
        end)

      {:file_sync, msg} ->
        IO.puts(inspect(msg))

      :hi ->
        IO.puts("Got hi")
    end

    listen()
  end
end
