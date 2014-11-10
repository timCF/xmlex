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

  test "xpath" do
  	raw_xml = """
  	<ROOT>
  		<child a="1">
  			<subchild a="1">
  				subchild1
  			</subchild>
  		</child>
  		<child>
   			<subchild a="2">
  				subchild2
  			</subchild>
   			<subchild a="3">
  				subchild3
  			</subchild>
  		</child>
   		<child>
   			<subchild b="4">
  				subchild4
  			</subchild>
  		</child>
  	</ROOT>
  	"""
	decoded_xml = Xmlex.decode!(raw_xml)

  assert Xmlex.get(decoded_xml, %{path: [:ROOT, :child, :subchild], target: %{attr: :a}}) == ["1", "2", "3"]
	assert Xmlex.get(decoded_xml, %{path: [:ROOT, :child, :subchild], target: %{attr: :b}}) == ["4"]
	assert Xmlex.get(decoded_xml, %{path: [:ROOT, :child, :subchild], target: :tagtext}) == ["subchild1", "subchild2", "subchild3", "subchild4"]
	assert Xmlex.get(decoded_xml, %{path: [:ROOT, :child], target: %{attr: :a}}) == ["1"]

  assert Xmlex.get!(raw_xml, %{path: [:ROOT, :child, :subchild], target: %{attr: :a}}) == ["1", "2", "3"]
	assert Xmlex.get!(raw_xml, %{path: [:ROOT, :child, :subchild], target: %{attr: :b}}) == ["4"]
	assert Xmlex.get!(raw_xml, %{path: [:ROOT, :child, :subchild], target: :tagtext}) == ["subchild1", "subchild2", "subchild3", "subchild4"]
	assert Xmlex.get!(raw_xml, %{path: [:ROOT, :child], target: %{attr: :a}}) == ["1"]

  end

  test "not throw exceptions" do
    xml_bad_binary = "<BetradarLiveOdd timestamp=\"1260866431052\" time=\"840\" status=\"clearbet\" replytype=\"current\" replynr=\"4\"><Match status=\"1p\" matchtime=\"1\" matchid=\"935448\" clearedscore=\"0:0\" betstatus=\"stopped\" active=\"1\"><Odds typeid=\"7\" type=\"ft2w\" subtype=\"2\" id=\"247509\" freetext=\"Which team has kick off?\" combination=\"0\" active=\"1\"><OddsField type=\"1\" outcome=\"0\" active=\"1\"/><OddsField type=\"2\" outcome=\"1\" active=\"1\"/></Odds></Match></BetradarLiveOdds>"
    assert %Xmlex.XML{} != Xmlex.decode(xml_bad_binary) |> IO.inspect
    assert %Xmlex.XML{} != Xmlex.decode("trololo") |> IO.inspect
    assert %Xmlex.XML{} != Xmlex.decode({:qwe}) |> IO.inspect
  end

end
