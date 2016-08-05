defmodule SimpleBayes.Test.ModelHelper do
  def train_list(sbayes, cat, [head | tail]) do
    sbayes = SimpleBayes.train(sbayes, cat, head)
    train_list(sbayes, cat, tail)
  end

  def train_list(sbayes, _cat, []), do: sbayes
end
