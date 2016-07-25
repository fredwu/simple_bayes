defmodule SimpleBayes.Storage.Behaviour do
  @callback init(%SimpleBayes{}, Keyword.t) :: pid
  @callback save(pid, Keyword.t)            :: {:ok, pid}
  @callback load(Keyword.t)                 :: pid
end
