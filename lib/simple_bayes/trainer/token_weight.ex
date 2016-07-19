defmodule SimpleBayes.Trainer.TokenWeight do
  @doc """
  Gets the token weight from either the training or the default config.

  ## Examples

      iex> SimpleBayes.Trainer.TokenWeight.from(weight: 2)
      2

      iex> SimpleBayes.Trainer.TokenWeight.from(default_weight: 1)
      1
  """
  def from(opts) do
    opts[:weight] || opts[:default_weight]
  end
end
