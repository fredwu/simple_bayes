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

    assert Agent.get(result, &(&1)) == %SimpleBayes{
      categories: %{
        cat: %{"nice" => 1, "cute" => 1, "cat" => 1},
        dog: %{"nice" => 2, "dog" => 3, "cute" => 1}
      },
      tokens: %{"nice" => 3, "cute" => 2, "cat" => 1, "dog" => 3}
    }
  end
end
