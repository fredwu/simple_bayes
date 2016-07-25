defmodule SimpleBayes.Storage.Memory do
  @behaviour SimpleBayes.Storage.Behaviour

  def init(struct, opts) do
    {:ok, pid} = case opts[:namespace] do
      nil -> Agent.start_link(fn -> struct end)
      _   -> Agent.start_link(fn -> struct end, name: opts[:namespace])
    end

    pid
  end

  def save(pid, _data) do
    pid
  end

  def load(opts) do
    opts[:namespace]
  end
end
