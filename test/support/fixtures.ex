defmodule XmerlC14n.Fixtures do
  @moduledoc """
  Helper functions to read an XML file from a known fixtures directory and
  parse it with `xmerl`.
  """

  @fixtures_dir "/test/fixtures/c14n"

  def read_fixture(fixture_name) do
    fixture_path =
      File.cwd!()
      |> List.wrap()
      |> Kernel.++([@fixtures_dir, fixture_name])
      |> Path.join()
      |> Kernel.<>(".xml")

    case File.read(fixture_path) do
      {:ok, file} ->
        file
        |> String.trim()

      {:error, code} ->
        raise "Could not load fixture file: #{fixture_path}, error: #{code}"
    end
  end

  def parse_xml(fixture_name) do
    {doc, _} =
      fixture_name
      |> read_fixture()
      |> to_charlist()
      |> :xmerl_scan.string(namespace_conformant: true, document: true)

    doc
  end
end
