defmodule SimpleBayesTest do
  use ExUnit.Case, async: true

  doctest SimpleBayes

  test ".init" do
    assert SimpleBayes.init
  end

  describe "integration" do
    setup do
      result = SimpleBayes.init
               |> SimpleBayes.train(:apple, "red sweet")
               |> SimpleBayes.train(:apple, "green", weight: 0.5)
               |> SimpleBayes.train(:apple, "round", weight: 2)
               |> SimpleBayes.train(:banana, "sweet")
               |> SimpleBayes.train(:banana, "green", weight: 0.5)
               |> SimpleBayes.train(:banana, "yellow long", weight: 2)
               |> SimpleBayes.train(:orange, "red")
               |> SimpleBayes.train(:orange, "yellow sweet", weight: 0.5)
               |> SimpleBayes.train(:orange, "round", weight: 2)

      {:ok, result: result}
    end

    test "README example on .classify", meta do
      result = meta.result
      |> SimpleBayes.classify("Maybe green maybe red but definitely round and sweet")
      |> Keyword.keys()

      assert result == [:apple, :orange, :banana]
    end

    test "README example on .classify_one", meta do
      assert SimpleBayes.classify_one(meta.result, "Maybe green maybe red but definitely round and sweet") == :apple
    end
  end

  test "stop words" do
    result = SimpleBayes.init
             |> SimpleBayes.train(:apple, "it is so red")
             |> SimpleBayes.train(:banana, "it is a bit yellow")
             |> SimpleBayes.classify_one("it is so much yellow")

    assert result == :banana
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

  test "string categories" do
    result = SimpleBayes.init
             |> SimpleBayes.train("apple", "red", weight: 100)
             |> SimpleBayes.train("banana", "red", weight: 0.01)
             |> SimpleBayes.train("orange", "red", weight: 10)
             |> SimpleBayes.classify("red")
             |> Keyword.keys()

    assert result == ["apple", "orange", "banana"]
  end

  test "IDF (Inverse Document Frequency)" do
    result = SimpleBayes.init
             |> SimpleBayes.train(:apple, "red red fruit")
             |> SimpleBayes.train(:banana, "yellow yellow fruit")
             |> SimpleBayes.train(:orange, "orange yellow fruit")
             |> SimpleBayes.classify("red yellow fruit")

    assert result[:apple] > result[:banana]
  end

  # https://github.com/jekyll/classifier-reborn/tree/3488245735905187713823ea731fc353634d8763
  describe "interesting and uninteresting" do
    setup do
      result = SimpleBayes.init
               |> SimpleBayes.train(:interesting, "here are some good words. I hope you love them")
               |> SimpleBayes.train(:interesting, "all you need is love")
               |> SimpleBayes.train(:interesting, "the love boat, soon we will be taking another ride")
               |> SimpleBayes.train(:interesting, "ruby don't take your love to town")
               |> SimpleBayes.train(:uninteresting, "here are some bad words, I hate you")
               |> SimpleBayes.train(:uninteresting, "bad bad leroy brown badest man in the darn town")
               |> SimpleBayes.train(:uninteresting, "the good the bad and the ugly")
               |> SimpleBayes.train(:uninteresting, "java, javascript, css front-end html")

      {:ok, result: result}
    end

    test "I hate bad words and you", meta do
      assert SimpleBayes.classify_one(meta.result, "I hate bad words and you") == :uninteresting
    end

    test "I hate javascript", meta do
      assert SimpleBayes.classify_one(meta.result, "I hate javascript") == :uninteresting
    end

    test "javascript is bad", meta do
      assert SimpleBayes.classify_one(meta.result, "javascript is bad") == :uninteresting
    end

    test "all you need is ruby", meta do
      assert SimpleBayes.classify_one(meta.result, "all you need is ruby") == :interesting
    end

    test "i love ruby", meta do
      assert SimpleBayes.classify_one(meta.result, "i love ruby") == :interesting
    end
  end

  # https://github.com/jekyll/classifier-reborn/tree/3488245735905187713823ea731fc353634d8763
  describe "dogs and cats" do
    setup do
      result = SimpleBayes.init
               |> SimpleBayes.train(:dog, "dog days of summer")
               |> SimpleBayes.train(:dog, "a man's best friend is his dog")
               |> SimpleBayes.train(:dog, "a good hunting dog is a fine thing")
               |> SimpleBayes.train(:dog, "man my dogs are tired")
               |> SimpleBayes.train(:dog, "dogs are better than cats in soooo many ways")
               |> SimpleBayes.train(:cat, "the fuzz ball spilt the milk")
               |> SimpleBayes.train(:cat, "got rats or mice get a cat to kill them")
               |> SimpleBayes.train(:cat, "cats never come when you call them")
               |> SimpleBayes.train(:cat, "That dang cat keeps scratching the furniture")

      {:ok, result: result}
    end

    test "which is better dogs or cats", meta do
      assert SimpleBayes.classify_one(meta.result, "which is better dogs or cats") == :dog
    end

    test "what do I need to kill rats and mice", meta do
      assert SimpleBayes.classify_one(meta.result, "what do I need to kill rats and mice") == :cat
    end
  end
end
