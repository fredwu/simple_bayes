defmodule SimpleBayes.Classifier do
  alias SimpleBayes.{Accumulator, Tokenizer}

  def classify_one(agent, string) do
    classify(agent, string) |> Enum.at(0) |> elem(0)
  end

  def classify(agent, string) do
    Agent.get(agent, &(&1))
    |> probabilities(string)
    |> Enum.sort(&(elem(&1,1) > elem(&2,1)))
  end

  defp probabilities(data, string) do
    cat_map = Tokenizer.tokenize(string)
              |> Tokenizer.map_values(SimpleBayes.smoothing)

    Map.new(data.categories, fn ({cat, [_, tokens: cat_tokens_map]}) ->
      prior = prior_for(cat_tokens_map, data.tokens)

      probability = probability_of(
        cat_map, cat_tokens_map, prior, data.trainings, data.tokens_per_training
      )

      {cat, probability}
    end)
  end

  defp prior_for(cat_tokens_map, tokens_map) do
    Accumulator.all(cat_tokens_map) / Accumulator.all(tokens_map)
  end

  defp probability_of(cat_map, cat_tokens_map, prior, trainings_count, tokens_per_training) do
    filtered_tokens_map = Map.take(cat_tokens_map, Map.keys(cat_map))

    likelihood = cat_map
                 |> Map.merge(filtered_tokens_map)
                 |> values_with_idf(trainings_count, tokens_per_training)
                 |> Enum.reduce(1, &(&1 + &2))

    :math.log10(likelihood) * prior
  end

  defp values_with_idf(tokens_map, trainings_count, tokens_per_training) do
    Enum.map(tokens_map, fn ({token, weight}) ->
      trainings_hit_count = trainings_hit_count_for(token, tokens_per_training)
      tf_idf_for(weight, trainings_count, trainings_hit_count)
    end)
  end

  defp trainings_hit_count_for(cat, tokens_per_training) do
    tokens_per_training
    |> Enum.filter(fn ({_cat, tokens}) -> Map.has_key?(tokens, cat) end)
    |> Enum.count
  end

  defp tf_idf_for(tf, numerator, denominator) do
    cond do
      denominator == 0         -> tf
      denominator == numerator -> tf
      true                     -> tf * :math.log10(numerator / denominator)
    end
  end
end
