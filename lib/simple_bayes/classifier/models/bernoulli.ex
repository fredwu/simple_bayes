defmodule SimpleBayes.Classifier.Model.Bernoulli do
  def probability_of(category, categories_map, data) do
    cat_trainings    = data.categories[category][:trainings]
    denominator_base = cat_trainings + 2

    numerator   = cat_trainings * category_numerator(category, denominator_base, categories_map, data)
    denominator = data.trainings * :math.pow(denominator_base, Kernel.map_size(data.tokens))

    numerator / denominator
  end

  defp category_numerator(category, denominator_base, categories_map, data) do
    Enum.reduce(data.tokens, 1, fn ({token, _}, acc) ->
      token_in_trainings = data.tokens_per_training
        |> Enum.filter(fn ({{cat, cat_tokens_map}, _}) ->
          cat == category && Map.has_key?(cat_tokens_map, token)
        end)
        |> Enum.count()

      value = if Map.has_key?(categories_map, token) do
        token_in_trainings + 1
      else
        denominator_base - (token_in_trainings + 1)
      end

      value * acc
    end)
  end
end
