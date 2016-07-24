defmodule SimpleBayes.MultinomialTest do
  use ExUnit.Case, async: true

  describe "multinomial" do
    test "stop words" do
      result = SimpleBayes.init
               |> SimpleBayes.train(:apple, "it is so red")
               |> SimpleBayes.train(:banana, "it is a bit yellow")
               |> SimpleBayes.classify_one("it is so much yellow")

      assert result == :banana
    end

    test "only stop words" do
      result = SimpleBayes.init
               |> SimpleBayes.train(:apple, "is so much")
               |> SimpleBayes.train(:banana, "it so much")
               |> SimpleBayes.classify("it is so much yellow")

      assert result[:apple] == result[:banana]
    end

    test "smoothing" do
      result = SimpleBayes.init(smoothing: 1)
               |> SimpleBayes.train("apple", "red")
               |> SimpleBayes.train("banana", "yellow")
               |> SimpleBayes.train("orange", "orange")
               |> SimpleBayes.classify("red")
               |> Keyword.keys()

      assert result == ["orange", "banana", "apple"]
    end

    test "ordering" do
      result = SimpleBayes.init
               |> SimpleBayes.train(:apple, "red", weight: 100)
               |> SimpleBayes.train(:banana, "red", weight: 0.01)
               |> SimpleBayes.train(:orange, "red", weight: 10)
               |> SimpleBayes.classify("red")
               |> Keyword.keys()

      assert result == [:apple, :orange, :banana]
    end

    test "IDF (Inverse Document Frequency)" do
      result = SimpleBayes.init
               |> SimpleBayes.train(:apple, "red red fruit")
               |> SimpleBayes.train(:banana, "yellow yellow fruit")
               |> SimpleBayes.train(:orange, "orange yellow fruit")
               |> SimpleBayes.classify("red yellow fruit")

      assert result[:apple] > result[:banana]
    end

    test "stemming" do
      result = SimpleBayes.init(stem: true)
               |> SimpleBayes.train(:apple, "buying apple")
               |> SimpleBayes.train(:banana, "buy banana")
               |> SimpleBayes.classify("buy apple")

      assert result[:apple] > result[:banana]
    end
  end
end
