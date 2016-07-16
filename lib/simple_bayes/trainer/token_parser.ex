defmodule SimpleBayes.Trainer.TokenParser do
  alias SimpleBayes.{Tokenizer, Trainer.TokenWeight}

  @doc """
  ## Examples

      iex> SimpleBayes.Trainer.TokenParser.parse(
      iex>   %SimpleBayes{},
      iex>   "cute dog",
      iex>   %{}
      iex> )
      {
        ["cute", "dog"],
        %SimpleBayes{tokens: %{"cute" => 1, "dog" => 1}}
      }

      iex> SimpleBayes.Trainer.TokenParser.parse(
      iex>   %SimpleBayes{tokens:  %{"cute" => 1, "cat" => 1}},
      iex>   "cute dog",
      iex>   %{}
      iex> )
      {
        ["cute", "dog"],
        %SimpleBayes{tokens: %{"cute" => 2, "cat" => 1, "dog" => 1}}
      }
  """
  def parse(data, string, opts) do
    tokens = string
             |> Tokenizer.tokenize()
             |> Tokenizer.filter_out(SimpleBayes.stop_words)

    data = %{data | tokens: accumulate(data.tokens, tokens, opts)}

    {tokens, data}
  end

  defp accumulate(tokens_map, tokens, opts) do
    Tokenizer.accumulate(tokens_map, tokens, TokenWeight.from(opts))
  end
end
