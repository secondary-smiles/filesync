defmodule Filesync.Receiver do
  def listen() do
    receive do
      {:hello, remote} ->
        send(remote, :hi)

      {:check_files, remote, files} ->
        send(remote, {:files_check, Filesync.File.check_files(files)})

      {:sync_file, remote, file, path} ->
        send(remote, {:file_sync, Filesync.Sync.sync(file, path)})

      {:files_check, files} ->
        IO.puts(inspect(files))

      {:file_sync, msg} ->
        IO.puts(inspect(msg))

      :hi ->
        IO.puts("Got hi")
    end

    listen()
  end
end
