defmodule SimpleBayes.Tokenizer do
  @doc """
  Converts a string into a list of words.

  ## Examples

      iex> SimpleBayes.Tokenizer.tokenize("foobar")
      ["foobar"]

      iex> SimpleBayes.Tokenizer.tokenize("foo bar")
      ["foo", "bar"]

      iex> SimpleBayes.Tokenizer.tokenize(",foo  bar  .")
      ["foo", "bar"]

      iex> SimpleBayes.Tokenizer.tokenize("Foo bAr")
      ["foo", "bar"]

      iex> SimpleBayes.Tokenizer.tokenize("foo, bar")
      ["foo", "bar"]

      iex> SimpleBayes.Tokenizer.tokenize("foo bar.")
      ["foo", "bar"]

      iex> SimpleBayes.Tokenizer.tokenize(~s(fo-o's ba_r"ed.))
      ~w(fo-o's ba_r"ed)
  """
  def tokenize(string) do
    string
    |> String.downcase()
    |> String.replace(~r/[^0-9a-zA-Z _\-'"]+/, "")
    |> String.split()
  end

  @doc """
  Filters out a list based on another list.

  ## Examples

      iex> SimpleBayes.Tokenizer.filter_out(["foo", "bar", "baz"], ["baz"])
      ["foo", "bar"]

      iex> SimpleBayes.Tokenizer.filter_out(["foo", "bar", "baz"], ["baz", "bazz"])
      ["foo", "bar"]

      iex> SimpleBayes.Tokenizer.filter_out(["foo", "bar", "baz", "baz"], ["baz"])
      ["foo", "bar"]
  """
  def filter_out(list, filter_list) do
    Enum.reject list, &(&1 in filter_list)
  end

  @doc """
  Converts a list with a value into a map, and merges the maps with accumulated values.

  ## Examples

      iex> SimpleBayes.Tokenizer.accumulate(%{}, [:cat, :dog], 1)
      %{cat: 1, dog: 1}

      iex> SimpleBayes.Tokenizer.accumulate(%{cat: 1, fish: 1}, [:cat, :dog], 2)
      %{cat: 3, fish: 1, dog: 2}

      iex> SimpleBayes.Tokenizer.accumulate(%{cat: 1, fish: 1}, [:cat, :cat, :dog], 1)
      %{cat: 3, fish: 1, dog: 1}
  """
  def accumulate(map, list, acc_size) do
    list
    |> map_values(acc_size)
    |> Map.merge(map, fn (_k, v1, v2) -> v1 + v2 end)
  end

  @doc """
  Converts a list with a value into a map.

  ## Examples

      iex> SimpleBayes.Tokenizer.map_values([:cat, :dog], 1)
      %{cat: 1, dog: 1}

      iex> SimpleBayes.Tokenizer.map_values([:cat, :cat, :dog], 1)
      %{cat: 2, dog: 1}
  """
  def map_values(list, value) do
    Enum.reduce(list, %{}, fn (k, acc) ->
      v = if acc[k], do: value + acc[k], else: value

      Map.put(acc, k, v)
    end)
  end
end
