defmodule SimpleBayes.ClassifierTest do
  use ExUnit.Case, async: true

  doctest SimpleBayes.Classifier

  setup do
    data = %SimpleBayes{
      categories: %{
        cat: [trainings: 1, tokens: %{"nice" => 1, "cute" => 1, "cat" => 1}],
        dog: [trainings: 1, tokens: %{"nice" => 2, "dog" => 2}]
      },
      trainings: 2,
      tokens: %{"nice" => 3, "cute" => 1, "cat" => 1, "dog" => 2}
    }

    {:ok, agent} = Agent.start_link(fn -> data end)

    {:ok, data: data, agent: agent}
  end

  test ".classify", meta do
    assert SimpleBayes.classify(meta.agent, "such a nice and cute dog") == [
      dog: 0.39960988629793276,
      cat: 0.20472854071377028
    ]
  end
end
