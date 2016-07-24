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
  end

  describe "Bernoulli" do
    # http://nlp.stanford.edu/IR-book/html/htmledition/naive-bayes-text-classification-1.html
    test "China yes or no" do
      result = SimpleBayes.init(model: :bernoulli)
               |> SimpleBayes.train(:yes, "Chinese Beijing Chinese")
               |> SimpleBayes.train(:yes, "Chinese Chinese Shanghai")
               |> SimpleBayes.train(:yes, "Chinese Macao")
               |> SimpleBayes.train(:no, "Tokyo Japan Chinese")
               |> SimpleBayes.classify("Chinese Chinese Chinese Tokyo Japan")

      assert result[:yes] == 324/62500
      assert result[:no] == 64/2916
    end

    test "binary word counting" do
      result = SimpleBayes.init(model: :bernoulli)
               |> SimpleBayes.train(:apple, "red red green fruit")
               |> SimpleBayes.train(:banana, "yellow green fruit")
               |> SimpleBayes.train(:orange, "orange yellow fruit")
               |> SimpleBayes.classify("red yellow fruit")

      assert result[:apple] == result[:banana]
      assert result[:apple] == result[:orange]
    end

    test "stop words" do
      result = SimpleBayes.init(model: :bernoulli)
               |> SimpleBayes.train(:apple, "it is so red")
               |> SimpleBayes.train(:banana, "it is a bit yellow")
               |> SimpleBayes.classify_one("it is so much yellow")

      assert result == :banana
    end

    test "only stop words" do
      result = SimpleBayes.init(model: :bernoulli)
               |> SimpleBayes.train(:apple, "is so much")
               |> SimpleBayes.train(:banana, "it so much")
               |> SimpleBayes.classify("it is so much yellow")

      assert result[:apple] == result[:banana]
    end

    test "smoothing - should be ignored" do
      result = SimpleBayes.init(model: :bernoulli, smoothing: 1)
               |> SimpleBayes.train("apple", "red")
               |> SimpleBayes.train("banana", "yellow")
               |> SimpleBayes.train("orange", "orange")
               |> SimpleBayes.classify("red")
               |> Keyword.keys()

      assert result == ["apple", "orange", "banana"]
    end

    test "ordering" do
      result = SimpleBayes.init(model: :bernoulli)
               |> SimpleBayes.train(:apple, "red green orange")
               |> SimpleBayes.train(:banana, "red green")
               |> SimpleBayes.train(:orange, "red orange")
               |> SimpleBayes.classify("red green orange")
               |> Keyword.keys()

      assert result == [:apple, :orange, :banana]
    end

    test "keywords weighting - should be ignored" do
      result = SimpleBayes.init(model: :bernoulli)
               |> SimpleBayes.train(:apple, "red", weight: 100)
               |> SimpleBayes.train(:banana, "red", weight: 0.01)
               |> SimpleBayes.train(:orange, "red", weight: 10)
               |> SimpleBayes.classify("red")
               |> Keyword.keys()

      assert result != [:apple, :orange, :banana]
    end

    test "IDF (Inverse Document Frequency) - should be ignored" do
      result = SimpleBayes.init(model: :bernoulli)
               |> SimpleBayes.train(:apple, "red red fruit")
               |> SimpleBayes.train(:banana, "yellow yellow fruit")
               |> SimpleBayes.train(:orange, "orange yellow fruit")
               |> SimpleBayes.classify("red yellow fruit")

      assert result[:apple] == result[:banana]
    end

    test "stemming" do
      result = SimpleBayes.init(model: :bernoulli, stem: true)
               |> SimpleBayes.train(:apple, "buying apple")
               |> SimpleBayes.train(:banana, "buy banana")
               |> SimpleBayes.classify("buy apple")

      assert result[:apple] > result[:banana]
    end
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

  # http://fredwu.me/post/147855522498/i-accidentally-some-machine-learning-my-story-of
  test "my blog post example" do
    result = SimpleBayes.init
             |> SimpleBayes.train(:ruby, "I enjoyed using Rails and ActiveRecord for the most part.")
             |> SimpleBayes.train(:ruby, "The Ruby community is awesome.")
             |> SimpleBayes.train(:ruby, "There is a new framework called Hanami that's promising.")
             |> SimpleBayes.train(:ruby, "Please learn Ruby before you learn Rails.")
             |> SimpleBayes.train(:ruby, "We use Rails at work.")
             |> SimpleBayes.train(:elixir, "It has Phoenix which is a Rails-like framework.")
             |> SimpleBayes.train(:elixir, "Its author is a Rails core member, Jose Valim.")
             |> SimpleBayes.train(:elixir, "Phoenix and Rails are on many levels, comparable.")
             |> SimpleBayes.train(:elixir, "Phoenix has great performance.")
             |> SimpleBayes.train(:elixir, "I love Elixir.")
             |> SimpleBayes.train(:php, "I haven't written any PHP in years.")
             |> SimpleBayes.train(:php, "The PHP framework Laravel is inspired by Rails.")
             |> SimpleBayes.classify("I wrote some Rails code at work today.")

    assert result == [
      ruby:   0.20761437345986136,
      elixir: 0.08101868169313056,
      php:    0.019047884912605735
    ]
  end
end
