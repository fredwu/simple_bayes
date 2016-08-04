defmodule SimpleBayes.Storage.Memory do
  @behaviour SimpleBayes.Storage.Behaviour

  alias SimpleBayes.Data

  def init(struct, opts) do
    {:ok, pid} = case opts[:namespace] do
      nil -> Agent.start_link(fn -> struct end)
      _   -> Agent.start_link(fn -> struct end, name: opts[:namespace])
    end

    pid
  end

  def save(pid, struct) do
    {:ok, pid, Data.encode(struct)}
  end

  def load(encoded_data: data), do: data |> Data.decode() |> init([])
  def load(opts),               do: opts[:namespace]
end
