defmodule SimpleBayes.Trainer.TokenStemmer do
  @doc """
  Catalogs tokens based on their training categories.

  ## Examples

      iex> SimpleBayes.Trainer.TokenStemmer.stem("buying", nil)
      "buying"

      iex> SimpleBayes.Trainer.TokenStemmer.stem("buying", false)
      "buying"

      iex> SimpleBayes.Trainer.TokenStemmer.stem("buying", true)
      "buy"
  """
  def stem(word, true), do: Stemmer.stem(word)
  def stem(word, _),    do: word
end
