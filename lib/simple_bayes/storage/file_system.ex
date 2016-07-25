defmodule SimpleBayes.Storage.FileSystem do
  @behaviour SimpleBayes.Storage.Behaviour

  alias SimpleBayes.Data

  def init(struct, _opts) do
    {:ok, pid} = Agent.start_link(fn -> struct end)

    pid
  end

  def save(pid, struct) do
    File.write!(file_path(struct.opts), Data.encode(struct))

    pid
  end

  def load(opts) do
    struct = file_path(opts)
             |> File.read!()
             |> Data.decode()

    init(struct, opts)
  end

  defp file_path(opts) do
    opts[:file_path] || opts[:storage_config][:file_path]
  end
end
