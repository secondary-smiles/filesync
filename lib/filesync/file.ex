defmodule Filesync.File do
  @doc """
  Checks a list of filenames and returns a list of the ones that don't exist.
  """
  def check_files([file | files], acc \\ []) do
    cond do
      File.dir?(file) ->
        {:error, {:isdir, file}}

      File.exists?(file) ->
        check_files(files, acc)

      true ->
        check_files(files, [file | acc])
    end
  end

  def check_files([], acc) do
    {:ok, acc}
  end
end
