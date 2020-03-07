# CLI

The command-line client for [Tefter](https://tefter.io).

## Features

### Search

![search](https://i.imgur.com/y6KtJ2g.png)

### Aliases

![aliases](https://i.imgur.com/LB6LbHP.png)

### Bookmarks

![bookmarks](https://i.imgur.com/kVvM4kN.png)

**Filtering**

![filtering](https://i.imgur.com/LCWynDP.png)

**Commands**

![commands](https://i.imgur.com/6arscF3.png)

**Modals**

Use the `:s` command to display more details about the bookmark under the cursor.

![modals](https://i.imgur.com/p5YIIza.png)

## Usage

![usage](https://i.imgur.com/dGbncJY.png)

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
