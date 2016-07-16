defmodule SimpleBayes.Trainer do
  alias SimpleBayes.Trainer.{
    TokenParser,
    TokenRecorder,
    TokenCataloger,
    TrainingCounter
  }

  def train(agent, category, string, opts) do
    Agent.get(agent, &(&1))
    |> TokenParser.parse(string, opts)
    |> TokenRecorder.record(category, opts)
    |> TokenCataloger.catalog(category, opts)
    |> TrainingCounter.increment()
    |> update(agent)
  end

  defp update(data, agent) do
    Agent.update(agent, fn (_) -> data end)
    agent
  end
end
