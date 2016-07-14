defmodule SimpleBayes do
  @default_weight      1
  @mininum_probability 0.01

  defstruct categories: %{}, tokens: %{}

  def init do
    {:ok, agent} = Agent.start_link fn -> %SimpleBayes{} end

    agent
  end

  def default_weight,      do: @default_weight
  def mininum_probability, do: @mininum_probability

  defdelegate train(agent, category, string, opts \\ []), to: SimpleBayes.Trainer
  defdelegate classify(agent, string),                    to: SimpleBayes.Classifier
  defdelegate classify_one(agent, string),                to: SimpleBayes.Classifier
end
