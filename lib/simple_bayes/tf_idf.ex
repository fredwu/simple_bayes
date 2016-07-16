defmodule SimpleBayes.TfIdf do
  @doc """
  ## Examples

      iex> SimpleBayes.TfIdf.call(2, 0, 1)
      2

      iex> SimpleBayes.TfIdf.call(2, 1, 0)
      2

      iex> SimpleBayes.TfIdf.call(2, 1, 1)
      2

      iex> SimpleBayes.TfIdf.call(2, 2, 1)
      0.6020599913279624
  """
  def call(tf, numerator, denominator) do
    cond do
      denominator == 0         -> tf
      numerator   == 0         -> tf
      denominator == numerator -> tf
      true                     -> tf * :math.log10(numerator / denominator)
    end
  end
end
