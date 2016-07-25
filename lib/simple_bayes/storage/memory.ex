defmodule SimpleBayes.Storage.Memory do
  @behaviour SimpleBayes.Storage.Behaviour

  def init(struct, opts) do
    {:ok, pid} = case namespace(opts) do
      nil -> Agent.start_link(fn -> struct end)
      _   -> Agent.start_link(fn -> struct end, name: namespace(opts))
    end

    pid
  end

  def load(opts) do
    namespace(opts)
  end

  defp namespace(opts) do
    opts[:namespace] || opts[:storage_config][:namespace]
  end
end
