defmodule XmerlC14nTest do
  use ExUnit.Case

  import XmerlC14n.Fixtures

  describe "canonicalize!/3" do
    test "namespaces of returned elements are unmodified if no inclusive namespaces requested" do
      original_xml = parse_xml("original/inclusive_namespaces")

      canonicalized_xml = read_fixture("canonicalized/inclusive_namespaces_1")

      assert canonicalized_xml == XmerlC14n.canonicalize!(original_xml, false, [])
      assert {:ok, ^canonicalized_xml} = XmerlC14n.canonicalize(original_xml, false, [])
    end

    test "namespaces of returned elements are modified if inclusive namespaces requested" do
      original_xml = parse_xml("original/inclusive_namespaces")

      canonicalized_xml = read_fixture("canonicalized/inclusive_namespaces_2")

      assert canonicalized_xml == XmerlC14n.canonicalize!(original_xml, false, ['bar'])
      assert {:ok, ^canonicalized_xml} = XmerlC14n.canonicalize(original_xml, false, ['bar'])
    end
  end

  describe "canonicalize!/2" do
    # Examples from https://www.w3.org/TR/xml-c14n/
    # Test names are crap, but they're based off the existing Erlang tests,
    # which are somehow worse

    test "3.1 PIs, Comments, and Outside of Document Element" do
      original_xml = parse_xml("original/example_3_1")

      without_comments = read_fixture("canonicalized/example_3_1_without_comments")

      assert without_comments == XmerlC14n.canonicalize!(original_xml, false)
      assert {:ok, ^without_comments} = XmerlC14n.canonicalize(original_xml, false)

      with_comments = read_fixture("canonicalized/example_3_1_with_comments")

      assert with_comments == XmerlC14n.canonicalize!(original_xml, true)
      assert {:ok, ^with_comments} = XmerlC14n.canonicalize(original_xml, true)
    end

    test "3.2 Whitespace in Document Content" do
      original_xml = parse_xml("original/example_3_2")

      canonicalized_xml = read_fixture("canonicalized/example_3_2")

      assert canonicalized_xml == XmerlC14n.canonicalize!(original_xml, true)
      assert {:ok, ^canonicalized_xml} = XmerlC14n.canonicalize(original_xml, true)
    end

    test "3.3 Start and End Tags" do
      original_xml = parse_xml("original/example_3_3")

      canonicalized_xml = read_fixture("canonicalized/example_3_3")

      assert canonicalized_xml == XmerlC14n.canonicalize!(original_xml, true)
      assert {:ok, ^canonicalized_xml} = XmerlC14n.canonicalize(original_xml, true)
    end

    test "3.4 Character Modifications and Character References" do
      original_xml = parse_xml("original/example_3_4")

      canonicalized_xml = read_fixture("canonicalized/example_3_4")

      assert canonicalized_xml == XmerlC14n.canonicalize!(original_xml, true)
      assert {:ok, ^canonicalized_xml} = XmerlC14n.canonicalize(original_xml, true)
    end

    # Cases not tested in Erlang:
    # 3.5 Entity References
    #   Why? Example XML crashes :xmerl_scan.string
    # 3.6 UTF-8 Encoding
    #   Why? xml_safe_string appears to be leaving UTF8 chars alone, not
    #   converting to hex entities
    # 3.7 Document Subsets
    #   Why? :xmerl_scan doesn't seem to be able to parse the following complex
    #   XPath
    #   (//. | //@* | //namespace::*)
    #   [
    #     self::ietf:e1 or (parent::ietf:e1 and not(self::text() or self::e2))
    #     or
    #     count(id("E3")|ancestor-or-self::node()) = count(ancestor-or-self::node())
    #   ]
    # 3.8 Document Subsets and XML Attributes
    #   Why? Same as 3.7, unable to parse XPath properly
    #
    # These may be due to being written against a 2001 version of the spec,
    # where these cases didn't exist yet.

    test "XML is canonicalized without any namespace transformations" do
      original_xml = parse_xml("original/default_namespace_1")

      canonicalized_xml = read_fixture("canonicalized/default_namespace_1")

      assert canonicalized_xml == XmerlC14n.canonicalize!(original_xml, true)
      assert {:ok, ^canonicalized_xml} = XmerlC14n.canonicalize(original_xml, true)
    end

    test "More complex example of canonicalization without namespace transformations" do
      original_xml = parse_xml("original/default_namespace_2")

      canonicalized_xml = read_fixture("canonicalized/default_namespace_2")

      assert canonicalized_xml == XmerlC14n.canonicalize!(original_xml, true)
      assert {:ok, ^canonicalized_xml} = XmerlC14n.canonicalize(original_xml, true)
    end
  end

  describe "canonicalize!/1" do
    # NOTE: Not tested explicitly because it just calls canonicalize!/2 with a second
    # parameter of true, which is tested under that describe block
  end
end
