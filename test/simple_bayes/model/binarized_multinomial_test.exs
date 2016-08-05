defmodule SimpleBayes.BinarizedMultinomialTest do
  use ExUnit.Case, async: true

  alias SimpleBayes.ModelHelper

  describe "Binarized multinomial" do
    test "binary word counting" do
      result = SimpleBayes.init(model: :binarized_multinomial)
               |> SimpleBayes.train(:apple, "red red green fruit")
               |> SimpleBayes.train(:banana, "yellow green fruit")
               |> SimpleBayes.train(:orange, "orange yellow fruit")
               |> SimpleBayes.classify("red yellow fruit")

      assert result[:apple] == result[:banana]
      assert result[:apple] == result[:orange]
    end

    test "stop words" do
      result = SimpleBayes.init(model: :binarized_multinomial)
               |> SimpleBayes.train(:apple, "it is so red")
               |> SimpleBayes.train(:banana, "it is a bit yellow")
               |> SimpleBayes.classify_one("it is so much yellow")

      assert result == :banana
    end

    test "only stop words" do
      result = SimpleBayes.init(model: :binarized_multinomial)
               |> SimpleBayes.train(:apple, "is so much")
               |> SimpleBayes.train(:banana, "it so much")
               |> SimpleBayes.classify("it is so much yellow")

      assert result[:apple] == result[:banana]
    end

    test "smoothing - should be ignored" do
      result = SimpleBayes.init(model: :binarized_multinomial, smoothing: 1)
               |> SimpleBayes.train("apple", "red")
               |> SimpleBayes.train("banana", "yellow")
               |> SimpleBayes.train("orange", "orange")
               |> SimpleBayes.classify("red")
               |> Keyword.keys()

      assert result == ["apple", "orange", "banana"]
    end

    test "ordering" do
      result = SimpleBayes.init(model: :binarized_multinomial)
               |> SimpleBayes.train(:apple, "red green orange")
               |> SimpleBayes.train(:banana, "red green")
               |> SimpleBayes.train(:orange, "red orange")
               |> SimpleBayes.classify("red green orange")
               |> Keyword.keys()

      assert result == [:apple, :orange, :banana]
    end

    test "keywords weighting - should be ignored" do
      result = SimpleBayes.init(model: :binarized_multinomial)
               |> SimpleBayes.train(:apple, "red", weight: 100)
               |> SimpleBayes.train(:banana, "red", weight: 0.01)
               |> SimpleBayes.train(:orange, "red", weight: 10)
               |> SimpleBayes.classify("red")
               |> Keyword.keys()

      assert result != [:apple, :orange, :banana]
    end

    test "IDF (Inverse Document Frequency) - should be ignored" do
      result = SimpleBayes.init(model: :binarized_multinomial)
               |> SimpleBayes.train(:apple, "red red fruit")
               |> SimpleBayes.train(:banana, "yellow yellow fruit")
               |> SimpleBayes.train(:orange, "orange yellow fruit")
               |> SimpleBayes.classify("red yellow fruit")

      assert result[:apple] == result[:banana]
    end

    test "stemming" do
      result = SimpleBayes.init(model: :binarized_multinomial, stem: true)
               |> SimpleBayes.train(:apple, "buying apple")
               |> SimpleBayes.train(:banana, "buy banana")
               |> SimpleBayes.classify("buy apple")

      assert result[:apple] > result[:banana]
    end

    test "float overflow in calculations" do
      result = SimpleBayes.init(model: :binarized_multinomial)
               |> SimpleBayes.train(:apple, "red red green fruit")
               |> SimpleBayes.train(:banana, "yellow green fruit")
               |> SimpleBayes.train(:orange, "orange yellow fruit")

      list = for _ <- 1..20 do
        Enum.join([
          Faker.Address.street_address(true),
          Faker.App.author,
          Faker.Bitcoin.address,
          Faker.Commerce.product_name,
          Faker.Company.bs,
          Faker.Company.catch_phrase
        ], " ")
      end

      result = ModelHelper.train_list(result, :strawberry, list)
      |> SimpleBayes.classify("red yellow fruit")

      assert result[:apple] == result[:banana]
    end
  end
end
