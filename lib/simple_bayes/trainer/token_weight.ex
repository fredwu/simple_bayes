defmodule SimpleBayes.Trainer.TokenWeight do
  @doc """
  Gets the token weight from either the training or the default config.

  ## Examples

      iex> SimpleBayes.Trainer.TokenWeight.from(weight: 2)
      2

      iex> SimpleBayes.Trainer.TokenWeight.from(other_opt: 2)
      1

      iex> SimpleBayes.Trainer.TokenWeight.from(nil)
      1
  """
  def from(opts) do
    opts[:weight] || SimpleBayes.default_weight
  end
end
