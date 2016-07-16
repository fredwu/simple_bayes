defmodule SimpleBayes.Accumulator do
  @doc """
  ## Examples

      iex> SimpleBayes.Accumulator.all(%{"nice" => 3, "cute" => 1, "cat" => 1, "dog" => 2})
      7

      iex> SimpleBayes.Accumulator.all(%{"nice" => 3.5, "cute" => 1, "cat" => 1, "dog" => 2.2})
      7.7
  """
  def all(map) do
    map |> Map.values() |> Enum.reduce(&(&1+&2))
  end

  @doc """
  ## Examples

      iex> SimpleBayes.Accumulator.only(%{"nice" => 3, "cute" => 1, "cat" => 1, "dog" => 2}, ["nice", "cute"])
      4

      iex> SimpleBayes.Accumulator.only(%{"nice" => 3.5, "cute" => 1, "cat" => 1, "dog" => 2.2}, ["nice", "cute"])
      4.5
  """
  def only(map, keys) do
    map |> Map.take(keys) |> all()
  end

  @doc """
  ## Examples

      iex> SimpleBayes.Accumulator.occurance([
      iex>   {:cat, %{"nice" => 1, "cute" => 1, "cat" => 1}},
      iex>   {:dog, %{"nice" => 2, "dog" => 2}}
      iex> ], "cute")
      1

      iex> SimpleBayes.Accumulator.occurance([
      iex>   {:cat, %{"nice" => 1, "cute" => 1, "cat" => 1}},
      iex>   {:dog, %{"nice" => 2, "dog" => 2}}
      iex> ], "nice")
      2
  """
  def occurance(list, key) do
    Enum.reduce(list, 0, fn ({_, map}, acc) ->
      if Map.has_key?(map, key), do: acc + 1, else: acc
    end)
  end
end
