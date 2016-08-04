defmodule SimpleBayes.Storage.FileSystem do
  @behaviour SimpleBayes.Storage.Behaviour

  alias SimpleBayes.Data

  def init(struct, _opts) do
    {:ok, pid} = Agent.start_link(fn -> struct end)

    pid
  end

  def save(pid, struct) do
    encoded_data = Data.encode(struct)

    File.write!(struct.opts[:file_path], encoded_data)

    {:ok, pid, encoded_data}
  end

  def load(opts) do
    struct = opts[:file_path]
             |> File.read!()
             |> Data.decode()

    init(struct, opts)
  end
end
