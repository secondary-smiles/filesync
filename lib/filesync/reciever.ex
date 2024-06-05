defmodule Filesync.Receiver do
  def listen() do
    receive do
      {:hello, remote} -> send(remote, :hi)
    end

    listen()
  end
end
