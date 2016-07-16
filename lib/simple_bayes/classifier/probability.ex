defmodule SimpleBayes.Classifier.Probability do
  alias SimpleBayes.{Accumulator, MapMath, TfIdf}

  @doc """
  Calculates the probabilities for the categories based on the training set.

  ## Examples

      iex> SimpleBayes.Classifier.Probability.for_collection(
      iex>   %SimpleBayes{
      iex>     categories: %{
      iex>       cat: [trainings: 1, tokens: %{"nice" => 1, "cute" => 1, "cat" => 1}],
      iex>       dog: [trainings: 3, tokens: %{"nice" => 2, "dog" => 3, "cute" => 3}]
      iex>     },
      iex>     trainings: 4,
      iex>     tokens: %{"nice" => 3, "cute" => 4, "cat" => 1, "dog" => 3},
      iex>     tokens_per_training: [
      iex>       {:cat, %{"nice" => 1, "cute" => 1, "cat" => 1}},
      iex>       {:dog, %{"nice" => 2, "dog" => 2}},
      iex>       {:dog, %{"cute" => 1, "dog" => 1}},
      iex>       {:dog, %{"cute" => 2}}
      iex>     ]
      iex>   },
      iex>   %{"cute" => 4, "good" => 0.001}
      iex> )
      %{cat: 0.014049480213985624, dog: 0.10077121599138436}
  """
  def for_collection(data, categories_map) do
    Map.new(data.categories, fn ({cat, [_, tokens: cat_tokens_map]}) ->
      probability = probability_of(categories_map, cat_tokens_map, data)

      {cat, probability}
    end)
  end

  defp probability_of(categories_map, cat_tokens_map, data) do
    likelihood = likelihood_of(categories_map, cat_tokens_map, data)
    prior      = MapMath.fraction(cat_tokens_map, data.tokens)

    likelihood * prior
  end

  defp likelihood_of(categories_map, cat_tokens_map, data) do
    tokens_map = Map.take(cat_tokens_map, Map.keys(categories_map))

    categories_map
    |> Map.merge(tokens_map)
    |> values_with_idf(data.tokens_per_training, data.trainings)
    |> Enum.reduce(1, &(&1 + &2))
    |> :math.log10()
  end

  defp values_with_idf(tokens_map, tokens_list, trainings_count) do
    Enum.map(tokens_map, fn ({token, weight}) ->
      TfIdf.call(weight, trainings_count, Accumulator.occurance(tokens_list, token))
    end)
  end
end
