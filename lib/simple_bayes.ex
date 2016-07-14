defmodule SimpleBayes do
  defstruct categories: %{}, tokens: %{}

  def init do
    {:ok, agent} = Agent.start_link fn -> %SimpleBayes{} end

    agent
  end

  def default_weight,      do: Application.get_env(:simple_bayes, :default_weight)
  def mininum_probability, do: Application.get_env(:simple_bayes, :mininum_probability)
  def stop_words,          do: Application.get_env(:simple_bayes, :stop_words)

  defdelegate train(agent, category, string, opts \\ []), to: SimpleBayes.Trainer
  defdelegate classify(agent, string),                    to: SimpleBayes.Classifier
  defdelegate classify_one(agent, string),                to: SimpleBayes.Classifier
end
