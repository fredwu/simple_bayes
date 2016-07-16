defmodule SimpleBayes.Trainer do
  alias SimpleBayes.Tokenizer

  def train(agent, category, string, opts) do
    Agent.get(agent, &(&1))
    |> parse_tokens(string, opts)
    |> record_tokens(category, opts)
    |> catalog(category, opts)
    |> update_counter()
    |> update(agent)
  end

  defp parse_tokens(data, string, opts) do
    tokens = string
             |> Tokenizer.tokenize()
             |> Tokenizer.filter_out(SimpleBayes.stop_words)

    tokens_map = Tokenizer.accumulate(data.tokens, tokens, weight(opts))

    data = %{data | tokens: tokens_map}

    {tokens, data}
  end

  defp record_tokens({tokens, data}, category, opts) do
    tokens_map          = Tokenizer.accumulate(%{}, tokens, weight(opts))
    tokens_per_training = data.tokens_per_training ++ [{category, tokens_map}]

    data = %{data | tokens_per_training: tokens_per_training}

    {tokens, data}
  end

  defp catalog({tokens, data}, category, opts) do
    cat_tokens_list = data.categories[category] || [trainings: 0, tokens: %{}]

    trainings_count = cat_tokens_list[:trainings] + 1
    cat_tokens_map  = cat_tokens_list[:tokens]
    tokens_map      = Tokenizer.accumulate(cat_tokens_map, tokens, weight(opts))

    categories = Map.put(data.categories, category, [
      trainings: trainings_count, tokens: tokens_map
    ])

    %{data | categories: categories}
  end

  defp update_counter(data) do
    counter = data.trainings + 1

    %{data | trainings: counter}
  end

  defp update(data, agent) do
    Agent.update(agent, fn (_) -> data end)
    agent
  end

  defp weight(opts) do
    opts[:weight] || SimpleBayes.default_weight
  end
end
