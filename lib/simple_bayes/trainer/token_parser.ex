defmodule SimpleBayes.Trainer.TokenParser do
  alias SimpleBayes.{Tokenizer, Trainer.TokenWeight, Trainer.TokenStemmer}

  @doc """
  Parses a training string into tokens.

  ## Examples

      iex> SimpleBayes.Trainer.TokenParser.parse(
      iex>   %SimpleBayes{},
      iex>   "cute dog",
      iex>   [default_weight: 1, stop_words: []]
      iex> )
      {
        ["cute", "dog"],
        %SimpleBayes{tokens: %{"cute" => 1, "dog" => 1}}
      }

      iex> SimpleBayes.Trainer.TokenParser.parse(
      iex>   %SimpleBayes{tokens:  %{"cute" => 1, "cat" => 1}},
      iex>   "cute dog",
      iex>   [default_weight: 1, stop_words: []]
      iex> )
      {
        ["cute", "dog"],
        %SimpleBayes{tokens: %{"cute" => 2, "cat" => 1, "dog" => 1}}
      }
  """
  def parse(data, string, opts) do
    tokens = string
             |> Tokenizer.tokenize()
             |> Tokenizer.filter_out(opts[:stop_words])
             |> TokenStemmer.stem(opts[:stem])

    data = %{data | tokens: accumulate(data.tokens, tokens, opts)}

    {tokens, data}
  end

  defp accumulate(tokens_map, tokens, opts) do
    Tokenizer.accumulate(tokens_map, tokens, TokenWeight.from(opts))
  end
end
