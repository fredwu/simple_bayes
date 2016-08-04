defmodule SimpleBayes.ClassifierTest do
  use ExUnit.Case, async: true

  doctest SimpleBayes.Classifier

  setup do
    data = %SimpleBayes{
      categories: %{
        cat: [trainings: 1, tokens: %{"nice" => 1, "cute" => 1, "cat" => 1}],
        dog: [trainings: 3, tokens: %{"nice" => 2, "dog" => 3, "cute" => 3}]
      },
      trainings: 4,
      tokens: %{"nice" => 3, "cute" => 4, "cat" => 1, "dog" => 3},
      tokens_per_training: %{
        {:cat, %{"nice" => 1, "cute" => 1, "cat" => 1}} => nil,
        {:dog, %{"nice" => 2, "dog" => 2}} => nil,
        {:dog, %{"cute" => 1, "dog" => 1}} => nil,
        {:dog, %{"cute" => 2}} => nil
      },
      opts: [
        model:     :multinomial,
        smoothing: 0
      ]
    }

    {:ok, agent} = Agent.start_link(fn -> data end)

    {:ok, agent: agent}
  end

  test ".classify", meta do
    result = meta.agent
    |> SimpleBayes.classify("such a nice and cute dog")
    |> Keyword.keys()

    assert result == [:dog, :cat]
  end

  test ".classify with `top` option", meta do
    result = meta.agent
    |> SimpleBayes.classify("such a nice and cute dog", top: 1)
    |> Keyword.keys()

    assert result == [:dog]
  end
end
