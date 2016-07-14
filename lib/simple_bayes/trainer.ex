defmodule SimpleBayes.Trainer do
  alias SimpleBayes.Tokenizer

  def train(agent, category, string, opts) do
    Agent.get(agent, &(&1))
    |> parse_tokens(string, opts)
    |> catalog(category, opts)
    |> update(agent)
  end

  defp parse_tokens(data, string, opts) do
    new_tokens = string
                 |> Tokenizer.tokenize()
                 |> Tokenizer.filter_out(SimpleBayes.stop_words)

    tokens = Tokenizer.accumulate(data.tokens, new_tokens, weight(opts))

    data = %{data | tokens: tokens}

    {new_tokens, data}
  end

  defp catalog({tokens, data}, category, opts) do
    categories = merge_categories(data.categories, category, tokens, opts)

    %{data | categories: categories}
  end

  defp merge_categories(categories, category, tokens, opts) do
    cat_tokens = categories[category] || %{}
    tokens     = Tokenizer.accumulate(cat_tokens, tokens, weight(opts))

    Map.put(categories, category, tokens)
  end

  defp update(data, agent) do
    Agent.update(agent, fn (_) -> data end)
    agent
  end

  defp weight(opts) do
    opts[:weight] || SimpleBayes.default_weight
  end
end
