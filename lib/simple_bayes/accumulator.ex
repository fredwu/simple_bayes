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
end
