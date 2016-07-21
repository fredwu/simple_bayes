defmodule SimpleBayes.Classifier.Model.Multinomial do
  alias SimpleBayes.{Accumulator, MapMath, TfIdf}

  def probability_of(categories_map, cat_tokens_map, data) do
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
