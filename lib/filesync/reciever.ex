defmodule Filesync.Receiver do
  def listen() do
    receive do
      {:hello, remote} ->
        send(remote, :hi)

      {:check_files, remote, files} ->
        send(remote, {:files_check, Filesync.File.check_files(files)})

      {:files_check, files} ->
        IO.puts(inspect(files))

      :hi ->
        IO.puts("Got hi")
    end

    listen()
  end
end
