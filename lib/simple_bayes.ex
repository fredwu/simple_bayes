defmodule SimpleBayes do
  defstruct categories: %{},
            trainings: 0,
            tokens: %{},
            tokens_per_training: %{},
            opts: []

  @model          :multinomial
  @storage        :memory
  @namespace      nil
  @file_path      ""
  @default_weight 1
  @smoothing      0
  @stem           false
  @top            nil
  @stop_words ~w(
    a about above after again against all am an and any are aren't as at be
    because been before being below between both but by can't cannot could
    couldn't did didn't do does doesn't doing don't down during each few for from
    further had hadn't has hasn't have haven't having he he'd he'll he's her here
    here's hers herself him himself his how how's i i'd i'll i'm i've if in into
    is isn't it it's its itself let's me more most mustn't my myself no nor not of
    off on once only or other ought our ours ourselves out over own same shan't
    she she'd she'll she's should shouldn't so some such than that that's the
    their theirs them themselves then there there's these they they'd they'll
    they're they've this those through to too under until up very was wasn't we
    we'd we'll we're we've were weren't what what's when when's where where's
    which while who who's whom why why's with won't would wouldn't you you'd
    you'll you're you've your yours yourself yourselves
  )

  @storages %{
    memory:      SimpleBayes.Storage.Memory,
    file_system: SimpleBayes.Storage.FileSystem,
    dets:        SimpleBayes.Storage.Dets
  }

  def init(opts \\ []) do
    opts = Keyword.merge([
      model:          model,
      storage:        storage,
      namespace:      namespace,
      file_path:      file_path,
      default_weight: default_weight,
      smoothing:      smoothing,
      stem:           stem,
      top:            top,
      stop_words:     stop_words
    ], opts)

    struct = %SimpleBayes{opts: opts}

    @storages[opts[:storage]].init(struct, opts)
  end

  def save(pid) do
    struct = Agent.get(pid, &(&1))

    @storages[struct.opts[:storage]].save(pid, struct)
  end

  def load(opts \\ []) do
    storage = opts[:storage] || :memory

    @storages[storage].load(opts)
  end

  defdelegate train(pid, category, string, opts \\ []), to: SimpleBayes.Trainer
  defdelegate classify(pid, string, opts \\ []),        to: SimpleBayes.Classifier
  defdelegate classify_one(pid, string, opts \\ []),    to: SimpleBayes.Classifier

  defp model,          do: Application.get_env(:simple_bayes, :model)          || @model
  defp storage,        do: Application.get_env(:simple_bayes, :storage)        || @storage
  defp namespace,      do: Application.get_env(:simple_bayes, :namespace)      || @namespace
  defp file_path,      do: Application.get_env(:simple_bayes, :file_path)      || @file_path
  defp default_weight, do: Application.get_env(:simple_bayes, :default_weight) || @default_weight
  defp smoothing,      do: Application.get_env(:simple_bayes, :smoothing)      || @smoothing
  defp stem,           do: Application.get_env(:simple_bayes, :stem)           || @stem
  defp top,            do: Application.get_env(:simple_bayes, :top)            || @top
  defp stop_words,     do: Application.get_env(:simple_bayes, :stop_words)     || @stop_words
end
