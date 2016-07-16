defmodule SimpleBayes.TrainerTest do
  use ExUnit.Case, async: true

  doctest SimpleBayes.Trainer

  setup do
    {:ok, agent: SimpleBayes.init}
  end

  test ".train", meta do
    result = meta.agent
             |> SimpleBayes.train(:cat, "nice cute cat")
             |> SimpleBayes.train(:dog, "nice dog", weight: 2)
             |> SimpleBayes.train(:dog, "is cute dog")
             |> SimpleBayes.train(:dog, "cute cute")

    assert Agent.get(result, &(&1)) == %SimpleBayes{
      categories: %{
        cat: [trainings: 1, tokens: %{"nice" => 1, "cute" => 1, "cat" => 1}],
        dog: [trainings: 3, tokens: %{"nice" => 2, "dog" => 3, "cute" => 3}]
      },
      trainings: 4,
      tokens: %{"nice" => 3, "cute" => 4, "cat" => 1, "dog" => 3},
      tokens_per_training: [
        {:cat, %{"nice" => 1, "cute" => 1, "cat" => 1}},
        {:dog, %{"nice" => 2, "dog" => 2}},
        {:dog, %{"cute" => 1, "dog" => 1}},
        {:dog, %{"cute" => 2}}
      ]
    }
  end
end
