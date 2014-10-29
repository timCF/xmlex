defmodule Xmlex.Encoder do
	
	def encode!(content = %Xmlex.XML{}) do
		{:result, res} = ExTask.run(fn() -> encode_process(content) end)
							|> ExTask.await(:infinity)
		res
	end
	def encode(content) do
		case ExTask.run(fn() -> encode_process(content) end)
				|> ExTask.await(:infinity) do
			{:result, res} -> res
			err -> {:error, err}
		end
	end
	

	defp encode_process(content) do
		[recurs_encode(content)]
			|> :xmerl.export_simple_content(:xmerl_xml)
				|> List.flatten
				 	|> to_string
	end

	defp recurs_encode(%Xmlex.XML{tagname: tagname, tagtext: tagtext, attrs: attrs, childs: childs}) when (is_atom(tagname) and is_binary(tagtext) and (is_map(attrs)) and is_list(childs)) do
		{tagname, make_attrs_keylist(attrs), make_tagtext_and_childs(tagtext, childs)}
	end

	defp make_attrs_keylist(attrs) when is_map(attrs) do
		HashUtils.to_list(attrs)
			|> Enum.map(
				fn({k,v}) ->
					{prepare_attr_key(k), prepare_attr_val(v)}
				end)
	end
	defp prepare_attr_key(key) do
		case key do
			some when is_atom(some) -> some
			some when is_binary(some) -> String.to_atom(some)
			some when is_list(some) -> :erlang.list_to_atom(some)
		end
	end
	defp prepare_attr_val(val) do
		case val do
			some when is_list(some) -> some
			some when ( is_binary(some) or is_atom(some) or is_number(some) ) -> to_string(some) |> String.to_char_list
		end
	end
	defp make_tagtext_and_childs(tagtext, childs) do
		case tagtext do
			"" -> Enum.map(childs, &recurs_encode/1)
			some -> [prepare_attr_val(some) | Enum.map(childs, &recurs_encode/1)]
		end
	end

end