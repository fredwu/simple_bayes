defmodule SimpleBayes.Classifier.Probability do
  alias SimpleBayes.Classifier.Model

  @doc """
  Calculates the probabilities for the categories based on the training set.

  ## Examples

      iex> SimpleBayes.Classifier.Probability.for_collection(
      iex>   %SimpleBayes{
      iex>     categories: %{
      iex>       cat: [trainings: 1, tokens: %{"nice" => 1, "cute" => 1, "cat" => 1}],
      iex>       dog: [trainings: 3, tokens: %{"nice" => 2, "dog" => 3, "cute" => 3}]
      iex>     },
      iex>     trainings: 4,
      iex>     tokens: %{"nice" => 3, "cute" => 4, "cat" => 1, "dog" => 3},
      iex>     tokens_per_training: %{
      iex>       {:cat, %{"nice" => 1, "cute" => 1, "cat" => 1}} => nil,
      iex>       {:dog, %{"nice" => 2, "dog" => 2}} => nil,
      iex>       {:dog, %{"cute" => 1, "dog" => 1}} => nil,
      iex>       {:dog, %{"cute" => 2}} => nil
      iex>     }
      iex>   },
      iex>   :multinomial,
      iex>   %{"cute" => 4, "good" => 0}
      iex> )
      %{cat: 0.013944237739606595, dog: 0.10054155931755744}
  """
  def for_collection(data, model, categories_map) do
    Map.new(data.categories, fn ({cat, [_, tokens: cat_tokens_map]}) ->
      probability = case model do
        :multinomial ->
          Model.Multinomial.probability_of(categories_map, cat_tokens_map, data)
        :binarized_multinomial ->
          Model.BinarizedMultinomial.probability_of(categories_map, cat_tokens_map, data)
        :bernoulli ->
          Model.Bernoulli.probability_of(cat, categories_map, data)
      end

      {cat, probability}
    end)
  end
end
