defmodule SimpleBayes.Trainer do
  alias SimpleBayes.Trainer.{
    TokenParser,
    TokenRecorder,
    TokenCataloger,
    TrainingCounter
  }

  def train(pid, category, string, opts) do
    Agent.get_and_update(pid, fn (pid) ->
      opts = Keyword.merge(pid.opts, opts)

      state = pid
      |> TokenParser.parse(string, opts)
      |> TokenRecorder.record(category, opts)
      |> TokenCataloger.catalog(category, opts)
      |> TrainingCounter.increment()

      {pid, state}
    end)

    pid
  end
end
