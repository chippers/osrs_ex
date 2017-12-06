# osrs_ex
An elixir interface to the Oldschool Runescape APIs.

## Testing

Run `mix test` to test the package.  Run `mix test --include hiscores_api` to
have the tests hit the live Jagex Hiscores API.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `osrs_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:osrs_ex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/osrs_ex](https://hexdocs.pm/osrs_ex).
