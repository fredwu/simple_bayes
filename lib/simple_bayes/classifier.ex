defmodule SimpleBayes.Classifier do
  alias SimpleBayes.{Classifier.Probability, Tokenizer}

  def classify_one(agent, string) do
    classify(agent, string) |> Enum.at(0) |> elem(0)
  end

  def classify(agent, string) do
    Agent.get(agent, &(&1))
    |> Probability.for_collection(category_map(string))
    |> Enum.sort(&(elem(&1,1) > elem(&2,1)))
  end

  defp category_map(string) do
    Tokenizer.tokenize_with_values(string, SimpleBayes.smoothing)
  end
end
