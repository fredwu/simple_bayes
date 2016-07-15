defmodule SimpleBayes.Classifier do
  alias SimpleBayes.{Accumulator, Tokenizer}

  def classify(agent, string) do
    Agent.get(agent, &(&1))
    |> probabilities(string)
    |> Enum.sort(&(elem(&1,1) > elem(&2,1)))
  end

  def classify_one(agent, string) do
    classify(agent, string) |> Enum.at(0) |> elem(0)
  end

  defp probabilities(data, string) do
    tokens = Tokenizer.tokenize(string)
             |> Tokenizer.map_values(SimpleBayes.mininum_probability)

    prior_prob = Accumulator.all(data.tokens)

    Map.new(data.categories, fn ({cat, cat_tokens}) ->
      {cat, probability_of(tokens, cat_tokens, prior_prob)}
    end)
  end

  defp probability_of(tokens, cat_tokens, prior_prob) do
    base_rate = Accumulator.all(cat_tokens) / prior_prob

    filtered_tokens = Map.take(cat_tokens, Map.keys(tokens))

    likelihood = tokens
                 |> Map.merge(filtered_tokens)
                 |> Map.values()
                 |> Enum.reduce(1, &(&1*&2))

    :math.log10(likelihood * base_rate)
  end
end
