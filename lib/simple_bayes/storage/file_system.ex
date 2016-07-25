defmodule SimpleBayes.Storage.FileSystem do
  @behaviour SimpleBayes.Storage.Behaviour

  alias SimpleBayes.Data

  def init(struct, _opts) do
    {:ok, pid} = Agent.start_link(fn -> struct end)

    pid
  end

  def save(pid, struct) do
    File.write!(struct.opts[:file_path], Data.encode(struct))

    pid
  end

  def load(opts) do
    struct = opts[:file_path]
             |> File.read!()
             |> Data.decode()

    init(struct, opts)
  end
end
