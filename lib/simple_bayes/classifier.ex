defmodule SimpleBayes.Classifier do
  alias SimpleBayes.{Classifier.Probability, Tokenizer, Trainer.TokenStemmer}

  def classify_one(pid, string, opts) do
    classify(pid, string, opts) |> Enum.at(0) |> Kernel.elem(0)
  end

  def classify(pid, string, opts) do
    data = Agent.get(pid, &(&1))
    opts = Keyword.merge(data.opts, opts)

    data
    |> Probability.for_collection(opts[:model], category_map(string, opts))
    |> Enum.sort(&(Kernel.elem(&1,1) > Kernel.elem(&2,1)))
    |> take_top(opts[:top])
  end

  defp category_map(string, opts) do
    string
    |> Tokenizer.tokenize()
    |> TokenStemmer.stem(opts[:stem])
    |> Tokenizer.map_values(opts[:smoothing])
  end

  defp take_top(result, nil), do: result
  defp take_top(result, num) when Kernel.is_integer(num) do
    result
    |> Enum.chunk(num)
    |> Enum.at(0)
  end
end
