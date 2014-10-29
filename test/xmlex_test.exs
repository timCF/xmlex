defmodule XmlexTest do
  use ExUnit.Case

  #res = {:Root, [a: 1, b: 'str'], [{:Child, [c: 3], []},{:Child, [d: 5], ['qwe']}]}
  #str = :xmerl.export_simple_content([res], :xmerl_xml) |> List.flatten |> to_string

  test "the truth" do
    assert 1 + 1 == 2
  end
end
