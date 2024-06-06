defmodule Filesync.File do
  @doc """
  Checks a list of filenames and corresponding hashes and returns a list of the ones that don't exist or have different hashes.
  """
  def check_files(files, acc \\ [])

  def check_files([{file, hash} | files], acc) do
    cond do
      File.dir?(file) ->
        {:error, {:isdir, file}}

      File.exists?(file) && hash == checksum(file) ->
        check_files(files, acc)

      true ->
        check_files(files, [file | acc])
    end
  end

  def check_files([], acc) do
    {:ok, acc}
  end

  @doc """
  Recursively list all the files in the given directory `path` and compute a checksum.
  """
  def all_files(path \\ ".") do
    cond do
      File.regular?(path) ->
        [{path, checksum(path)}]

      File.dir?(path) ->
        File.ls!(path)
        |> Enum.map(fn x -> Path.join(path, x) end)
        |> Enum.map(&all_files/1)
        |> Enum.concat()

      true ->
        []
    end
  end

  def checksum(file) do
    hasher = :crypto.hash_init(:sha256)

    File.stream!(file)
    |> Enum.reduce(hasher, fn chunk, prev ->
      new = :crypto.hash_update(prev, chunk)
      new
    end)
    |> :crypto.hash_final()
    |> Base.encode16()
  end
end
