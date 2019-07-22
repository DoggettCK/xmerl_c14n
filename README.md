# XmerlC14n

[![Hex Version][hex-img]][hex] [![Hex Downloads][downloads-img]][downloads] [![License][license-img]][license]

[hex-img]: https://img.shields.io/hexpm/v/xmerl_c14n.svg
[hex]: https://hex.pm/packages/xmerl_c14n
[downloads-img]: https://img.shields.io/hexpm/dt/xmerl_c14n.svg
[downloads]: https://hex.pm/packages/xmerl_c14n
[license-img]: https://img.shields.io/badge/license-BSD-blue.svg
[license]: https://opensource.org/licenses/BSD-2-Clause

`XmerlC14n` canonicalizes XML according to the [Exclusive XML Canonicalization
specification version 1.0](http://www.w3.org/2001/10/xml-exc-c14n#), for use in
XML signatures.

It is a port to Elixir from the `xmerl_c14n` Erlang module found in the [esaml
project](https://github.com/arekinath/esaml).

Documentation is located at
[https://hexdocs.pm/xmerl_c14n](https://hexdocs.pm/xmerl_c14n)

## Installation

`XmerlC14n` can be installed by adding `xmerl_c14n` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:xmerl_c14n, "~> 0.1.0"}
  ]
end
```

## Examples

`XmerlC14n` operates on `xmerl` Erlang records, typically seen as tuples. These
can be parsed directly from the included Erlang modules in Elixir, using
`:xmerl_scan.string`, or with a nice wrapper, like
[SweetXml](https://github.com/kbrw/sweet_xml).

```elixir
iex> xml = ~S{<!DOCTYPE doc [<!ATTLIST e9 attr CDATA "default">]>
<doc>
   <e1   />
   <e2   ></e2>
   <e3   name = "elem3"   id="elem3"   />
   <e4   name="elem4"   id="elem4"   ></e4>
   <e5 a:attr="out" b:attr="sorted" attr2="all" attr="I'm"
      xmlns:b="http://www.ietf.org"
      xmlns:a="http://www.w3.org"
      xmlns="http://example.org"/>
   <e6 xmlns="" xmlns:a="http://www.w3.org">
      <e7 xmlns="http://www.ietf.org">
         <e8 xmlns="" xmlns:a="http://www.w3.org">
            <e9 xmlns="" xmlns:a="http://www.ietf.org"/>
         </e8>
      </e7>
   </e6>
</doc>
}
iex> {xml_tuples, _} = xml |> to_charlist |> :xmerl_scan.string(namespace_conformant: true, document: true)
{:xmlDocument,
  [
  {:xmlElement, :doc, :doc, [], {:xmlNamespace, [], []}, [], 1, [],
    [
    {:xmlText, [doc: 1], 1, [], '\n   ', :text},
    {:xmlElement, :e1, :e1, [], {:xmlNamespace, [], []}, [doc: 1], 2, [], [],
      [], '', :undeclared},
    {:xmlText, [doc: 1], 3, [], '\n   ', :text},
    {:xmlElement, :e2, :e2, [], {:xmlNamespace, [], []}, [doc: 1], 4, [], [],
      [], :undefined, :undeclared},
    {:xmlText, [doc: 1], 5, [], '\n   ', :text},
    {:xmlElement, :e3, :e3, [], {:xmlNamespace, [], []}, [doc: 1], 6,
      [
      {:xmlAttribute, :name, :name, [], {:xmlNamespace, [], []},
        [e3: 6, doc: 1], 1, [], 'elem3', false},
      {:xmlAttribute, :id, :id, [], {:xmlNamespace, [], []}, [e3: 6, doc: 1],
        2, [], 'elem3', false}
      ], [], [], :undefined, :undeclared},
    {:xmlText, [doc: 1], 7, [], '\n   ', :text},
    {:xmlElement, :e4, :e4, [], {:xmlNamespace, [], []}, [doc: 1], 8,
      [
      {:xmlAttribute, :name, :name, [], {:xmlNamespace, [], []},
        [e4: 8, doc: 1], 1, [], 'elem4', false},
      {:xmlAttribute, :id, :id, [], {:xmlNamespace, [], []}, [e4: 8, doc: 1],
        2, [], 'elem4', false}
      ], [], [], :undefined, :undeclared},
    {:xmlText, [doc: 1], 9, [], '\n   ', :text},
    {:xmlElement, :e5, {:"http://example.org", :e5}, [],
      {:xmlNamespace, :"http://example.org",
        [{'b', :"http://www.ietf.org"}, {'a', :"http://www.w3.org"}]}, [doc: 1],
      10,
      [
      {:xmlAttribute, :"a:attr", {:"http://www.w3.org", :attr},
        {'a', 'attr'},
        {:xmlNamespace, :"http://example.org",
          [{'b', :"http://www.ietf.org"}, {'a', :"http://www.w3.org"}]},
        [e5: 10, doc: 1], 1, [], 'out', false},
      {:xmlAttribute, :"b:attr", {:"http://www.ietf.org", :attr},
        {'b', 'attr'},
        {:xmlNamespace, :"http://example.org",
          [{'b', :"http://www.ietf.org"}, {'a', :"http://www.w3.org"}]},
        [e5: 10, doc: 1], 2, [], 'sorted', false},
      {:xmlAttribute, :attr2, :attr2, [],
        {:xmlNamespace, :"http://example.org",
          [{'b', :"http://www.ietf.org"}, {'a', :"http://www.w3.org"}]},
        [e5: 10, doc: 1], 3, [], 'all', false},
      {:xmlAttribute, :attr, :attr, [],
        {:xmlNamespace, :"http://example.org",
          [{'b', :"http://www.ietf.org"}, {'a', :"http://www.w3.org"}]},
        [e5: 10, doc: 1], 4, [], 'I\'m', false},
      {:xmlAttribute, :"xmlns:b", {'xmlns', 'b'}, {'xmlns', 'b'},
        {:xmlNamespace, :"http://example.org",
          [{'b', :"http://www.ietf.org"}, {'a', :"http://www.w3.org"}]},
        [e5: 10, doc: 1], 5, [], 'http://www.ietf.org', false},
        {:xmlAttribute, :"xmlns:a", {'xmlns', 'a'}, {'xmlns', 'a'},
          {:xmlNamespace, :"http://example.org",
            [{'b', :"http://www.ietf.org"}, {'a', :"http://www.w3.org"}]},
          [e5: 10, doc: 1], 6, [], 'http://www.w3.org', false},
          {:xmlAttribute, :xmlns, :xmlns, [],
            {:xmlNamespace, :"http://example.org",
              [{'b', :"http://www.ietf.org"}, {'a', :"http://www.w3.org"}]},
            [e5: 10, doc: 1], 7, [], 'http://example.org', false}
      ], [], [], :undefined, :undeclared},
    {:xmlText, [doc: 1], 11, [], '\n   ', :text},
    {:xmlElement, :e6, {:"", :e6}, [],
      {:xmlNamespace, :"", [{'a', :"http://www.w3.org"}]}, [doc: 1], 12,
      [
      {:xmlAttribute, :xmlns, :xmlns, [],
        {:xmlNamespace, :"", [{'a', :"http://www.w3.org"}]}, [e6: 12, doc: 1],
        1, [], [], false},
      {:xmlAttribute, :"xmlns:a", {'xmlns', 'a'}, {'xmlns', 'a'},
        {:xmlNamespace, :"", [{'a', :"http://www.w3.org"}]}, [e6: 12, doc: 1],
        2, [], 'http://www.w3.org', false}
      ],
      [
      {:xmlText, [e6: 12, doc: 1], 1, [], '\n      ', :text},
      {:xmlElement, :e7, {:"http://www.ietf.org", :e7}, [],
        {:xmlNamespace, :"http://www.ietf.org", [{'a', :"http://www.w3.org"}]},
        [e6: 12, doc: 1], 2,
        [
        {:xmlAttribute, :xmlns, :xmlns, [], {:xmlNamespace, ...}, [...],
          ...}
        ],
        [
        {:xmlText, [e7: 2, e6: 12, doc: 1], 1, [], '\n         ', ...},
        {:xmlElement, :e8, {:"", ...}, [], ...},
        {:xmlText, [e7: 2, ...], 3, ...}
        ], [], :undefined, :undeclared},
      {:xmlText, [e6: 12, doc: 1], 3, [], '\n   ', :text}
      ], [], :undefined, :undeclared},
    {:xmlText, [doc: 1], 13, [], '\n', :text}
    ], [], '', :undeclared}
  ]}
iex> xml_tuples |> XmerlC14n.canonicalize!() |> IO.puts()
<doc>
  <e1></e1>
  <e2></e2>
  <e3 id="elem3" name="elem3"></e3>
  <e4 id="elem4" name="elem4"></e4>
  <e5 xmlns="http://example.org" xmlns:a="http://www.w3.org" xmlns:b="http://www.ietf.org" attr="I'm" attr2="all" b:attr="sorted" a:attr="out"></e5>
  <e6>
    <e7 xmlns="http://www.ietf.org">
      <e8 xmlns="">
        <e9></e9>
      </e8>
    </e7>
  </e6>
</doc>
```

If using [SweetXml](https://github.com/kbrw/sweet_xml), you neither have to
convert your XML to a charlist, nor destructure it from a tuple.

```elixir
iex> xml |> SweetXml.parse(namespace_conformant: true, document: true) |> XmerlC14n.canonicalize!() |> IO.puts()
<doc>
  <e1></e1>
  <e2></e2>
  <e3 id="elem3" name="elem3"></e3>
  <e4 id="elem4" name="elem4"></e4>
  <e5 xmlns="http://example.org" xmlns:a="http://www.w3.org" xmlns:b="http://www.ietf.org" attr="I'm" attr2="all" b:attr="sorted" a:attr="out"></e5>
  <e6>
    <e7 xmlns="http://www.ietf.org">
      <e8 xmlns="">
        <e9></e9>
      </e8>
    </e7>
  </e6>
</doc>
```

For more examples see https://hexdocs.pm/xmerl_c14n/XmerlC14n.html#canonicalize/1-examples
