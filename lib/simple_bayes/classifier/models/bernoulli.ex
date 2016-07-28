defmodule SimpleBayes.Classifier.Model.Bernoulli do
  def probability_of(category, categories_map, data) do
    numerator   = cat_trainings_count(category, data)
                  * token_count(category, categories_map, data)

    denominator = data.trainings
                  * :math.pow(
                    cat_base_count(category, data),
                    Kernel.map_size(data.tokens)
                  )

    numerator / denominator
  end

  defp token_count(category, categories_map, data) do
    Enum.reduce(data.tokens, 1, fn ({token, _}, acc) ->
      count = trainings_with_token_count(
        data.tokens_per_training, category, token
      ) + 1

      value = if Map.has_key?(categories_map, token) do
        count
      else
        cat_base_count(category, data) - count
      end

      value * acc
    end)
  end

  defp trainings_with_token_count(tokens_map, category, token) do
    tokens_map
    |> Enum.filter(fn ({{cat, cat_tokens_map}, _}) ->
      cat == category && Map.has_key?(cat_tokens_map, token)
    end)
    |> Enum.count()
  end

  defp cat_trainings_count(category, data) do
    data.categories[category][:trainings]
  end

  defp cat_base_count(category, data) do
    cat_trainings_count(category, data) + 2
  end
end
