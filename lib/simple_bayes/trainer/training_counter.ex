defmodule SimpleBayes.Trainer.TrainingCounter do
  @doc """
  Increments and updates the training count.

  ## Examples

      iex> SimpleBayes.Trainer.TrainingCounter.increment(%{trainings: 1})
      %{trainings: 2}
  """
  def increment(data) do
    counter = data.trainings + 1

    %{data | trainings: counter}
  end
end
