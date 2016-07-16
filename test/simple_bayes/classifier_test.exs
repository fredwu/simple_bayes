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
    result = meta.agent
    |> SimpleBayes.classify("such a nice and cute dog")
    |> Keyword.keys()

    assert result == [:dog, :cat]
  end
end
