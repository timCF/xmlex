defmodule XmlexTest do
  use ExUnit.Case

  test "decoder" do
  	tree = {:Root, [{:undefined, "1"}, {nil, 'str'}], [{:Child, [c: "3.22"], []},{:Child, [true: "5"], [' qwe we']},{:Child, [true: "5"], ['content', {:Sub, [], []}]}]}
  	str = :xmerl.export_simple_content([tree], :xmerl_xml) |> List.flatten |> to_string
    assert Xmlex.decode!(str) == %Xmlex.XML{
			    					attrs: %{undefined: "1", nil: "str"},
			 						tagname: :Root,
			 						tagtext: "",
			 						childs: 
			 							[
			 								%Xmlex.XML{attrs: %{c: "3.22"}, childs: [], tagname: :Child, tagtext: ""},
			  								%Xmlex.XML{attrs: %{true: "5"}, childs: [], tagname: :Child, tagtext: "qwe we"},
			  								%Xmlex.XML{attrs: %{true: "5"}, childs: [ %Xmlex.XML{attrs: %{}, childs: [], tagname: :Sub, tagtext: ""} ], tagname: :Child, tagtext: "content"}
  										]}
  end

  test "encoder" do
  	assert "<Root a=\"1\">content</Root>" == %Xmlex.XML{attrs: %{a: 1}, tagtext: "content", tagname: :Root} |> Xmlex.encode!
  end

  test "cyclical 1" do
  	xml_struct = %Xmlex.XML{
		    					attrs: %{undefined: "1", nil: "str"},
		 						tagname: :Root,
		 						tagtext: "",
		 						childs: 
		 							[
		 								%Xmlex.XML{attrs: %{c: "3.22"}, childs: [], tagname: :Child, tagtext: ""},
		  								%Xmlex.XML{attrs: %{true: "5"}, childs: [], tagname: :Child, tagtext: "qwe we"},
		  								%Xmlex.XML{attrs: %{true: "5"}, childs: [ %Xmlex.XML{attrs: %{}, childs: [], tagname: :Sub, tagtext: ""} ], tagname: :Child, tagtext: "content"}
										]}
	assert xml_struct == xml_struct |> Xmlex.encode! |> Xmlex.decode!
  end

  test "cyclical 2" do
	xml_binary = "<BetradarLiveOdds timestamp=\"1260866431052\" time=\"840\" status=\"clearbet\" replytype=\"current\" replynr=\"4\"><Match status=\"1p\" matchtime=\"1\" matchid=\"935448\" clearedscore=\"0:0\" betstatus=\"stopped\" active=\"1\"><Odds typeid=\"7\" type=\"ft2w\" subtype=\"2\" id=\"247509\" freetext=\"Which team has kick off?\" combination=\"0\" active=\"1\"><OddsField type=\"1\" outcome=\"0\" active=\"1\"/><OddsField type=\"2\" outcome=\"1\" active=\"1\"/></Odds></Match></BetradarLiveOdds>"
	assert xml_binary == xml_binary |> Xmlex.decode! |> Xmlex.encode!
  end

end
