defmodule SimpleBayes.Data do
  def encode(value, opts \\ []) do
    value
    |> Kernel.inspect(limit: 1_000_000_000)
    |> Base.encode64(opts)
  end

  def decode(value, opts \\ []) do
    {struct, _} = value
    |> Base.decode64!(opts)
    |> Code.eval_string()

    struct
  end
end
