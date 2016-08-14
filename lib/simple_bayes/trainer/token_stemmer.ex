defmodule SimpleBayes.Trainer.TokenStemmer do
  @doc """
  Stems the word using `stemmer`. Passes the word through if it is false.

  ## Examples

      iex> SimpleBayes.Trainer.TokenStemmer.stem("buying", false)
      "buying"

      iex> SimpleBayes.Trainer.TokenStemmer.stem("buying", &Stemmer.stem/1)
      "buy"
  """
  def stem(word, stemmer) when is_function(stemmer), do: stemmer.(word)
  def stem(word, _),                                 do: word
end
