defmodule SimpleBayes.ClassifierTest do
  use ExUnit.Case, async: true

  doctest SimpleBayes.Classifier

  setup do
    data = %SimpleBayes{
      categories: %{
        cat: %{"nice" => 1, "cute" => 1, "cat" => 1},
        dog: %{"nice" => 2, "dog" => 2}
      },
      tokens: %{"nice" => 3, "cute" => 1, "cat" => 1, "dog" => 2}
    }

    {:ok, agent} = Agent.start_link(fn -> data end)

    {:ok, data: data, agent: agent}
  end

  test ".classify", meta do
    assert SimpleBayes.classify(meta.agent, "such a nice and cute dog")
           == [dog: -11.640978057358332, cat: -12.367976785294594]
  end
end
