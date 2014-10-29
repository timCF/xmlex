defmodule Xmlex.Xpath do
	
	def get(subj, path)
	def get(subj = %Xmlex.XML{}, path) do
		get([subj], path)
	end
	def get([], _) do
		[]
	end
	def get(lst, path = %{path: []}) do
		case HashUtils.get(path, :target) do
			:tagtext -> Enum.map(lst, fn(%Xmlex.XML{tagtext: tagtext}) -> tagtext end)
			:attrs -> Enum.map(lst, fn(%Xmlex.XML{attrs: attrs}) -> attrs end)
			some when ((some == nil) or (some == :all)) -> Enum.map(lst, fn(res = %Xmlex.XML{}) -> res end)
			%{attr: attr} when is_atom(attr) -> Enum.map(lst, fn(%Xmlex.XML{attrs: attrs}) -> HashUtils.get(attrs, attr) end)
		end
		|> Enum.filter(&(&1 != nil))
	end
	def get(lst, path = %{path: [this|[]]}) do
		Enum.filter(lst,
			fn(%Xmlex.XML{tagname: tagname}) -> tagname == this end )
				|> List.flatten
					|> get( HashUtils.set(path, :path, []) )
	end
	def get(lst, path = %{path: [this|rest]}) do
		Enum.filter_map(lst,
			fn(%Xmlex.XML{tagname: tagname}) -> tagname == this end,
			fn(%Xmlex.XML{childs: childs}) -> childs end )
				|> List.flatten
					|> get( HashUtils.set(path, :path, rest) )
	end
	

end