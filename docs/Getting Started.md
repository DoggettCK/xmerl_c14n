# Getting Started

## Description

XmerlC14n implements XML canonicalization (c14n) for use in XML signing.

## Installation

The package can be installed by adding `xmerl_c14n` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:xmerl_c14n, "~> 0.1.0"}
  ]
end
```

## Why?

Cryptographically signing XML requires that a particular subdocument, for
example, the contents of a `soap:Body` element, be canonicalized. Necessary
namespace attributes that are outside the subdocument are pulled into it, and
duplicates merged at the lowest level that they are needed. Attributes are
sorted in a particular order, with `xmlns` namespaces coming first, then
un-namespaced attributes sorted alphabetically, then namespaced attributes
sorted not alphabetically by name, but alphabetically by the URI of their
associated namespace.

The only existing implementation I could find for this was in the
[esaml](https://github.com/arekinath/esaml) project, implemented in Erlang.
Unfortunately, I was unable to use the entire esaml project, as it required a
much older version of Cowboy than we were using. Using Erlang from an Elixir
project is very simple, just drop the module in the `src` directory, and use
`mix erlang.compile`. However, we ran into an edge case where we really could
have used `IO.inspect` to see what was happening internally. There are ways to
do similar debugging in Erlang, but I'm not as experienced with it, and prefer
Elixir's conventions, so I decided to port the module to Elixir, and here we
are.

## How does it work?

First, you'll need to load your XML into Erlang-compatible tuples. Technically,
they're Records, and you shouldn't rely on the fact that they're tuples under
the hood, but Records have been deprecated in Elixir, except specifically for
doing Erlang interop.

You can use Records from Elixir fairly easy using the macros in the `Record` module, or using the tuples directly.

```elixir
defmodule RecordTest do
  require Record

  Record.defrecord(:xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl"))
end

iex> require RecordTest
RecordTest
iex> RecordTest.xmlAttribute()
{:xmlAttribute, :undefined, [], [], [], [], :undefined, [], :undefined, :undefined}
iex> RecordTest.xmlAttribute(name: 'foo', value: 'bar')
{:xmlAttribute, 'foo', [], [], [], [], :undefined, [], 'bar', :undefined}
```

It's definitely easier to understand creating Records with a keyword list
instead of remembering that `:name` is the second value in the tuple after
`:xmlAttribute`, and that `:value` is the 9th. You more than likely won't have
to deal with the tuples yourself other than loading them from the library of
your choice. I highly recommend [SweetXml](https://github.com/kbrw/sweet_xml),
which is a thin Elixir wrapper around Erlang's `xmerl` module, but if you don't
want to pull in another dependency, `xmerl` is easy enough.

```elixir
# Parsing with xmerl
iex> xml = "<foo><bar>some text</bar></foo>"
"<foo><bar>some text</bar></foo>"
iex> {doc, _} = :xmerl_scan.string(to_charlist(xml), namespace_conformant: true, document: true)
{{:xmlDocument,
  [
  {:xmlElement, :foo, :foo, [], {:xmlNamespace, [], []}, [], 1, [],
    [
    {:xmlElement, :bar, :bar, [], {:xmlNamespace, [], []}, [foo: 1], 1, [],
      [{:xmlText, [bar: 1, foo: 1], 1, [], 'some text', :text}], [],
      '', :undeclared}
    ], [], '', :undeclared}
  ]}, []}


# Parsing with SweetXml
iex> doc = SweetXml.parse(xml, namespace_conformant: true, document: true)
{:xmlDocument,
 [
   {:xmlElement, :foo, :foo, [], {:xmlNamespace, [], []}, [], 1, [],
    [
      {:xmlElement, :bar, :bar, [], {:xmlNamespace, [], []}, [foo: 1], 1, [],
       [{:xmlText, [bar: 1, foo: 1], 1, [], 'some text', :text}], [],
       '', :undeclared}
    ], [], '', :undeclared}
 ]}
```

I prefer SweetXml because you don't have to worry about converting the string
to a charlist, or pulling the tuples out of the 2-tuple they're parsed into.

From there, you simply pass the tuples to `XmerlC14n.canonicalize!`, and it'll
spit back out the canonicalized XML string you need.

```elixir
iex> doc |> XmerlC14n.canonicalize!()
"<foo><bar>some text</bar></foo>"
iex> doc |> XmerlC14n.canonicalize()
{:ok, "<foo><bar>some text</bar></foo>"}
```

According to the usual Elixir way of doing things, there's a version with and
without the bang (`!`). `canonicalize` will return either `{:ok,
canonicalized_xml}` or `{:error, {:failed_canonicalization, error_message}}`,
while `canonicalize!` will either return just the canonicalized XML string, or
raise an `ArgumentError` for you to catch.

## Caveats

Currently, the API only accepts tuples of the kind used by `xmerl`, Erlang's
XML-processing library, but may accept strings/filenames in future versions.
