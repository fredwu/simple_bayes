defmodule SimpleBayes do
  defstruct categories: %{}, trainings: 0, tokens: %{}, tokens_per_training: []

  def init do
    {:ok, agent} = Agent.start_link fn -> %SimpleBayes{} end

    agent
  end

  def default_weight, do: Application.get_env(:simple_bayes, :default_weight)
  def smoothing,      do: Application.get_env(:simple_bayes, :smoothing)
  def stop_words,     do: Application.get_env(:simple_bayes, :stop_words)

  defdelegate train(agent, category, string, opts \\ []), to: SimpleBayes.Trainer
  defdelegate classify(agent, string),                    to: SimpleBayes.Classifier
  defdelegate classify_one(agent, string),                to: SimpleBayes.Classifier
end
