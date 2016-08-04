defmodule SimpleBayes.Storage.Behaviour do
  @callback init(%SimpleBayes{}, Keyword.t) :: pid
  @callback save(pid, %SimpleBayes{})       :: {:ok, pid, String.t}
  @callback load(Keyword.t)                 :: pid
end
