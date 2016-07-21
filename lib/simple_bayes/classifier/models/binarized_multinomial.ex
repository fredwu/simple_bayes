defmodule SimpleBayes.Classifier.Model.BinarizedMultinomial do
  def probability_of(categories_map, cat_tokens_map, data) do
    likelihood = likelihood_of(categories_map, cat_tokens_map)
    prior      = Enum.count(cat_tokens_map) / Enum.count(data.tokens)

    likelihood * prior
  end

  defp likelihood_of(categories_map, cat_tokens_map) do
    tokens_map = Map.take(cat_tokens_map, Map.keys(categories_map))

    tokens_map
    |> Kernel.map_size() || 1
    |> :math.log10()
  end
end
