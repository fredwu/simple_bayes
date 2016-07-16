defmodule SimpleBayes.Trainer.TokenCataloger do
  alias SimpleBayes.{Tokenizer, Trainer.TokenWeight}

  @doc """
  Catalogs tokens based on their training categories.

  ## Examples

      iex> SimpleBayes.Trainer.TokenCataloger.catalog(
      iex>   {
      iex>     ["cute", "dog"],
      iex>     %SimpleBayes{categories: %{}, trainings: 0, tokens: %{}}
      iex>   },
      iex>   :dog,
      iex>   %{}
      iex> )
      %SimpleBayes{
        categories: %{
          dog: [trainings: 1, tokens: %{"cute" => 1, "dog" => 1}]
        }
      }

      iex> SimpleBayes.Trainer.TokenCataloger.catalog(
      iex>   {
      iex>     ["cute", "cat"],
      iex>     %SimpleBayes{
      iex>       categories: %{
      iex>         dog: [trainings: 1, tokens: %{"cute" => 1, "dog" => 1}]
      iex>       }
      iex>     }
      iex>   },
      iex>   :cat,
      iex>   %{}
      iex> )
      %SimpleBayes{
        categories: %{
          dog: [trainings: 1, tokens: %{"cute" => 1, "dog" => 1}],
          cat: [trainings: 1, tokens: %{"cute" => 1, "cat" => 1}]
        }
      }

      iex> SimpleBayes.Trainer.TokenCataloger.catalog(
      iex>   {
      iex>     ["good", "cat"],
      iex>     %SimpleBayes{
      iex>       categories: %{
      iex>         dog: [trainings: 1, tokens: %{"cute" => 1, "dog" => 1}],
      iex>         cat: [trainings: 1, tokens: %{"cute" => 1, "cat" => 1}]
      iex>       }
      iex>     }
      iex>   },
      iex>   :cat,
      iex>   %{}
      iex> )
      %SimpleBayes{
        categories: %{
          dog: [trainings: 1, tokens: %{"cute" => 1, "dog" => 1}],
          cat: [trainings: 2, tokens: %{"cute" => 1, "cat" => 2, "good" => 1}]
        }
      }
  """
  def catalog({tokens, data}, category, opts) do
    cat_tokens_list = data.categories[category] || [trainings: 0, tokens: %{}]

    categories = Map.put(data.categories, category, [
      trainings: cat_tokens_list[:trainings] + 1,
      tokens:    tokens_map(cat_tokens_list[:tokens], tokens, opts)
    ])

    %{data | categories: categories}
  end

  defp tokens_map(cat_tokens_map, tokens, opts) do
    Tokenizer.accumulate(cat_tokens_map, tokens, TokenWeight.from(opts))
  end
end
