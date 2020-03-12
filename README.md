![logo](https://i.imgur.com/58c5csa.png)

The command-line client for [Tefter](https://tefter.io).

## Features

### Search

![search](https://i.imgur.com/y6KtJ2g.png)

Use `enter` to open a browser window with a result.

### Aliases

![aliases](https://i.imgur.com/LB6LbHP.png)

**Commands**

Create an alias

```
:c <alias> <url>
```

Delete an alias

```
:d
```

### Bookmarks

![bookmarks](https://i.imgur.com/kVvM4kN.png)

**Filtering**

![filtering](https://i.imgur.com/LCWynDP.png)

Use `/` to start filtering.

**Commands**

![commands](https://i.imgur.com/6arscF3.png)

Add a bookmark

```
:c <url>
```

Delete a bookmark

```
:d
```

**Modals**

Use the `:s` command to display more details about the bookmark under the cursor.

![modals](https://i.imgur.com/p5YIIza.png)

## Usage

![usage](https://i.imgur.com/dGbncJY.png)

**Shortcuts**

Key|Action
----|------|
<kbd>Ctrl</kbd>+<kbd>s</kbd>|Jump to Search tab
<kbd>Ctrl</kbd>+<kbd>a</kbd>|Jump to Aliases tab
<kbd>Ctrl</kbd>+<kbd>b</kbd>|Jump to Bookmarks tab
<kbd>Ctrl</kbd>+<kbd>h</kbd>|Jump to Help tab
<kbd>Tab</kbd>|Jump to the next tab
<kbd>Home</kbd>|Jump to the first tab
<kbd>↑</kbd>|Move up
<kbd>Ctrl</kbd>+<kbd>k</kbd>|Move up
<kbd>↓</kbd>|Move down
<kbd>Ctrl</kbd>+<kbd>j</kbd>|Move down
<kbd>Ctrl</kbd>+<kbd>d</kbd>|Scroll down
<kbd>Ctrl</kbd>+<kbd>u</kbd>|Scroll up
<kbd>Enter</kbd>| Open browser window with item under cursor
<kbd>Esc</kbd>|Cancel command / Quit modal
<kbd>F5</kbd>|Force refresh resources|
<kbd>Ctrl</kbd>+<kbd>q</kbd>|Quit
<kbd>/</kbd>|Enter filtering mode
<kbd>:</kbd>|Enter command mode

## Installation

Download a compatible release for your system from [releases](https://github.com/tefter/cli/releases).
Extract and run `tefter_cli`.

The first time you run it, it'll try to open a browser window to authenticate your Tefter account.
The alternative way to authenticate is to create a `~/.tefter` file with your API token.

```json
{
  "token": "your_token_here"
}
```

You will find your token [here](https://tefter.io/users/edit).

## Running Locally

First, ensure you have the following versions of Elixir and OTP installed on your machine.

```
erlang 21.3.2
elixir 1.9
```

Then, run:

```shell
git clone git@github.com:tefter/cli.git
mix deps.get
mix run --no-halt
```

## Releasing

You can build portable [releases](https://hexdocs.pm/mix/Mix.Tasks.Release.html) per platform,
which include the Erlang VM and don't require installing Erlang / Elixir on the target system.

### Linux

Run:

```shell
./bin/release_linux
```

### MacOS

Run:

```shell
./bin/release_macos
```

## License

Copyright (c) 2020 Tefter, GPLv3 License.
See [LICENSE.txt](https://github.com/tefter/cli/blob/master/LICENSE) for further details.
