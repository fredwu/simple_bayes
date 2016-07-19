defmodule SimpleBayes.Trainer.TokenRecorder do
  alias SimpleBayes.{Tokenizer, Trainer.TokenWeight}

  @doc """
  Records the tokens from each training.

  ## Examples

      iex> SimpleBayes.Trainer.TokenRecorder.record(
      iex>   {
      iex>     ["cute", "dog"],
      iex>     %SimpleBayes{}
      iex>   },
      iex>   :dog,
      iex>   [default_weight: 1]
      iex> )
      {
        ["cute", "dog"],
        %SimpleBayes{
          tokens_per_training: %{
            {:dog, %{"cute" => 1, "dog" => 1}} => nil
          }
        }
      }

      iex> SimpleBayes.Trainer.TokenRecorder.record(
      iex>   {
      iex>     ["good", "dog"],
      iex>     %SimpleBayes{
      iex>       tokens_per_training: %{
      iex>         {:dog, %{"cute" => 1, "dog" => 1}} => nil
      iex>       }
      iex>     }
      iex>   },
      iex>   :dog,
      iex>   [default_weight: 1]
      iex> )
      {
        ["good", "dog"],
        %SimpleBayes{
          tokens_per_training: %{
            {:dog, %{"cute" => 1, "dog" => 1}} => nil,
            {:dog, %{"good" => 1, "dog" => 1}} => nil
          }
        }
      }
  """
  def record({tokens, data}, category, opts) do
    tokens_per_training = Map.merge(
      data.tokens_per_training,
      %{{category, tokens_map(tokens, opts)} => nil}
    )

    data = %{data | tokens_per_training: tokens_per_training}

    {tokens, data}
  end

  defp tokens_map(tokens, opts) do
    Tokenizer.accumulate(%{}, tokens, TokenWeight.from(opts))
  end
end
