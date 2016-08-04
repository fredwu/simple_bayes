defmodule SimpleBayes.Storage.MemoryTest do
  use ExUnit.Case, async: true

  doctest SimpleBayes.Storage.Memory

  describe "memory storage" do
    setup do
      opts = [
        storage:   :memory,
        namespace: :memory_test
      ]

      SimpleBayes.init(opts)
      |> SimpleBayes.train(:apple, "red sweet")
      |> SimpleBayes.train(:apple, "green", weight: 0.5)
      |> SimpleBayes.train(:apple, "round", weight: 2)
      |> SimpleBayes.train(:banana, "sweet")
      |> SimpleBayes.save()

      SimpleBayes.load(opts)
      |> SimpleBayes.train(:banana, "green", weight: 0.5)
      |> SimpleBayes.train(:banana, "yellow long", weight: 2)
      |> SimpleBayes.train(:orange, "red")
      |> SimpleBayes.train(:orange, "yellow sweet", weight: 0.5)
      |> SimpleBayes.train(:orange, "round", weight: 2)
      |> SimpleBayes.save()

      {:ok, opts: opts}
    end

    test "README example on .classify", meta do
      result = SimpleBayes.load(meta.opts)
               |> SimpleBayes.classify("Maybe green maybe red but definitely round and sweet")
               |> Keyword.keys()

      assert result == [:apple, :orange, :banana]
    end

    test "README example on .classify_one", meta do
      result = SimpleBayes.load(meta.opts)
               |> SimpleBayes.classify_one("Maybe green maybe red but definitely round and sweet")

      assert result == :apple
    end
  end

  describe "memory storage for passing encoded data" do
    setup do
      {:ok, _pid, encoded_data} = SimpleBayes.init()
      |> SimpleBayes.train(:apple, "red sweet")
      |> SimpleBayes.train(:apple, "green", weight: 0.5)
      |> SimpleBayes.train(:apple, "round", weight: 2)
      |> SimpleBayes.train(:banana, "sweet")
      |> SimpleBayes.save()

      {:ok, _pid, encoded_data} = SimpleBayes.load(encoded_data: encoded_data)
      |> SimpleBayes.train(:banana, "green", weight: 0.5)
      |> SimpleBayes.train(:banana, "yellow long", weight: 2)
      |> SimpleBayes.train(:orange, "red")
      |> SimpleBayes.train(:orange, "yellow sweet", weight: 0.5)
      |> SimpleBayes.train(:orange, "round", weight: 2)
      |> SimpleBayes.save()

      opts = [encoded_data: encoded_data]

      {:ok, opts: opts}
    end

    test "README example on .classify", meta do
      result = SimpleBayes.load(meta.opts)
               |> SimpleBayes.classify("Maybe green maybe red but definitely round and sweet")
               |> Keyword.keys()

      assert result == [:apple, :orange, :banana]
    end

    test "README example on .classify_one", meta do
      result = SimpleBayes.load(meta.opts)
               |> SimpleBayes.classify_one("Maybe green maybe red but definitely round and sweet")

      assert result == :apple
    end
  end
end
