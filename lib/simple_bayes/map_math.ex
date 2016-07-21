defmodule SimpleBayes.MapMath do
  alias SimpleBayes.Accumulator

  @doc """
  Calculates the fraction.

  ## Examples

      iex> SimpleBayes.MapMath.fraction(
      iex>   %{"nice" => 2, "cute" => 1, "cat" => 1},
      iex>   %{"nice" => 2, "dog" => 2}
      iex> )
      1.0

      iex> SimpleBayes.MapMath.fraction(
      iex>   %{"nice" => 2, "cute" => 1, "cat" => 1},
      iex>   %{"nice" => 1, "dog" => 1}
      iex> )
      2.0

      iex> SimpleBayes.MapMath.fraction(
      iex>   %{},
      iex>   %{"nice" => 1, "dog" => 1}
      iex> )
      0.5
  """
  def fraction(map1, map2) do
    Accumulator.all(map1) / Accumulator.all(map2)
  end
end
