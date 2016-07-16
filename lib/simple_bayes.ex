defmodule SimpleBayes do
  defstruct categories: %{}, trainings: 0, tokens: %{}, tokens_per_training: []

  @default_weight 1
  @smoothing 0.001
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

  def init do
    {:ok, agent} = Agent.start_link fn -> %SimpleBayes{} end

    agent
  end

  def default_weight, do: Application.get_env(:simple_bayes, :default_weight) || @default_weight
  def smoothing,      do: Application.get_env(:simple_bayes, :smoothing)      || @smoothing
  def stop_words,     do: Application.get_env(:simple_bayes, :stop_words)     || @stop_words

  defdelegate train(agent, category, string, opts \\ []), to: SimpleBayes.Trainer
  defdelegate classify(agent, string),                    to: SimpleBayes.Classifier
  defdelegate classify_one(agent, string),                to: SimpleBayes.Classifier
end
