defmodule SimpleBayes.Tokenizer do
  @doc """
  ## Examples

      iex> SimpleBayes.Tokenizer.tokenize("foobar")
      ["foobar"]

      iex> SimpleBayes.Tokenizer.tokenize("foo bar")
      ["foo", "bar"]

      iex> SimpleBayes.Tokenizer.tokenize("foo, bar")
      ["foo", "bar"]

      iex> SimpleBayes.Tokenizer.tokenize("foo bar.")
      ["foo", "bar"]
  """
  def tokenize(string) do
    Regex.replace(~r/[^0-9a-zA-Z ]+/, string, "") |> String.split()
  end

  @doc """
  ## Examples

      iex> SimpleBayes.Tokenizer.filter_out(["foo", "bar", "baz"], ["baz"])
      ["foo", "bar"]

      iex> SimpleBayes.Tokenizer.filter_out(["foo", "bar", "baz"], ["baz", "bazz"])
      ["foo", "bar"]
  """
  def filter_out(list, filter_list) do
    list -- filter_list
  end

  @doc """
  ## Examples

      iex> SimpleBayes.Tokenizer.accumulate(%{}, [:cat, :dog], 1)
      %{cat: 1, dog: 1}

      iex> SimpleBayes.Tokenizer.accumulate(%{cat: 1, fish: 1}, [:cat, :dog], 2)
      %{cat: 3, fish: 1, dog: 2}
  """
  def accumulate(map, list, acc_size) do
    list
    |> map_values(acc_size)
    |> Map.merge(map, fn (_k, v1, v2) -> v1 + v2 end)
  end

  @doc """
  ## Examples

      iex> SimpleBayes.Tokenizer.map_values([:cat, :dog], 1)
      %{cat: 1, dog: 1}
  """
  def map_values(list, value) do
    Enum.reduce(list, %{}, fn (x, acc) -> Map.put(acc, x, value) end)
  end
end
