## TODO implement rsync for efficiency
defmodule Filesync.Sync do
  def sync_files([{file, hash} | files]) do
  end

  @doc """
  Overwrites `path` with contents of remote `file`.
  """
  def sync(remote, file) do
    {:ok, contents} = :rpc.call(remote, File, :read, [file])
    File.mkdir_p!(Path.dirname(file))
    File.write!(file, contents)
    {:ok, file}
  end
end
