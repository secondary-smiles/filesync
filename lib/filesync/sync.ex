## TODO implement rsync for efficiency
defmodule Filesync.Sync do
  def sync_files([{file, hash} | files]) do
  end

  @doc """
  Overwrites `path` with contents of remote `file`.
  """
  def sync(file, path) do
    contents = IO.read(file)
    IO.puts("sync '#{path}': #{inspect(contents)}")
  end
end
