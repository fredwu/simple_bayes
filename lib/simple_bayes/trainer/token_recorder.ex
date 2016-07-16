defmodule SimpleBayes.Trainer.TokenRecorder do
  alias SimpleBayes.{Tokenizer, Trainer.TokenWeight}

  @doc """
  ## Examples

      iex> SimpleBayes.Trainer.TokenRecorder.record(
      iex>   {
      iex>     %{"cute" => 1, "dog" => 1},
      iex>     %SimpleBayes{}
      iex>   },
      iex>   :dog,
      iex>   %{}
      iex> )
      {
        %{"cute" => 1, "dog" => 1},
        %SimpleBayes{
          tokens_per_training: [dog: %{{"cute", 1} => 1, {"dog", 1} => 1}]
        }
      }

      iex> SimpleBayes.Trainer.TokenRecorder.record(
      iex>   {
      iex>     %{"cute" => 1, "good" => 1},
      iex>     %SimpleBayes{
      iex>       tokens_per_training: [dog: %{{"cute", 1} => 1, {"dog", 1} => 1}]
      iex>     }
      iex>   },
      iex>   :dog,
      iex>   %{}
      iex> )
      {
        %{"cute" => 1, "good" => 1},
        %SimpleBayes{
          tokens_per_training: [
            dog: %{{"cute", 1} => 1, {"dog", 1} => 1},
            dog: %{{"cute", 1} => 1, {"good", 1} => 1}
          ]
        }
      }
  """
  def record({tokens, data}, category, opts) do
    tokens_per_training = data.tokens_per_training ++ [
      {category, tokens_map(tokens, opts)}
    ]

    data = %{data | tokens_per_training: tokens_per_training}

    {tokens, data}
  end

  defp tokens_map(tokens, opts) do
    Tokenizer.accumulate(%{}, tokens, TokenWeight.from(opts))
  end
end
