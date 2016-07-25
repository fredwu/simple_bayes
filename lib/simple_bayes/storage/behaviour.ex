defmodule SimpleBayes.Storage.Behaviour do
  @callback init(%SimpleBayes{}, Keyword.t) :: pid
  @callback load(Keyword.t) :: pid
end
