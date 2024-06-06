# Filesync

Stupid little tool that syncs files in a directory between two computers. I wrote this to explore the Elixir programming language, so the code is awful and the end-product barely functions.

## To run:

```bash
# Edit flake.nix to customize the local user, sync location and cookie
$EDITOR flake.nix

# Start the dev environment
nix develop 

# Start the repl
iex -S mix
```

Now, setup the program:

```bash
iex> Filesync.Node.start_link({:"user@remote", :cookie})
```

Now, go to your sync folder and try using `touch` and `echo` to make some files:
```bash
touch new_file
echo "sync me!" > another_file
```

Hopefully they should show up on the other machine as well!
