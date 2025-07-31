### **`README.md`**

# compile.nvim

`compile.nvim` is a Neovim plugin that automatically sets the `:make` command based on a `.nvim-compile` file found in the current working directory or any parent directory (up to a configurable depth).

## Features

* Dynamically sets Neovim’s built-in `makeprg` option.
* Searches for a `.nvim-compile` file up the directory tree.
* Automatically updates on buffer enter, directory changes, or when `.nvim-compile` is saved.
* Falls back to the default `make` command if no file is found.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "mewsen/compile.nvim"
}
```

## Usage

Create a `.nvim-compile` file in your project directory:

```
go build ./cmd/server
```

When you open Neovim inside the project and run:

```
:make
```

It will automatically execute the command from `.nvim-compile`.

If no `.nvim-compile` file is found, the default `make` command is used.

## Configuration

You can change the search depth and default build command:

```lua
require("compile.nvim").setup({
  max_depth = 7,
  default_makeprg = "make"
})
```

## Documentation

After installation, run:

```
:helptags ALL
:help compile.nvim
```

## License

MIT License

