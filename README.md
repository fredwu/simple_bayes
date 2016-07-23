# Simple Bayes [![Travis](https://img.shields.io/travis/fredwu/simple_bayes.svg)](https://travis-ci.org/fredwu/simple_bayes) [![Hex.pm](https://img.shields.io/hexpm/v/simple_bayes.svg)](https://hex.pm/packages/simple_bayes)

A Simple Bayes (a.k.a. [Naive Bayes](https://en.wikipedia.org/wiki/Naive_Bayes_classifier)) implementation in Elixir.

> In machine learning, __naive Bayes classifiers__ are a family of simple probabilistic classifiers based on applying Bayes' theorem with strong (naive) independence assumptions between the features.

> Naive Bayes has been studied extensively since the 1950s. It was introduced under a different name into the text retrieval community in the early 1960s, and remains a popular (baseline) method for text categorization, the problem of judging documents as belonging to one category or the other (such as spam or legitimate, sports or politics, etc.) with word frequencies as the features. With appropriate preprocessing, it is competitive in this domain with more advanced methods including support vector machines. It also finds application in automatic medical diagnosis.

> Naive Bayes classifiers are highly scalable, requiring a number of parameters linear in the number of variables (features/predictors) in a learning problem. Maximum-likelihood training can be done by evaluating a closed-form expression, which takes linear time, rather than by expensive iterative approximation as used for many other types of classifiers. - [Wikipedia](https://en.wikipedia.org/wiki/Naive_Bayes_classifier)

## Features

- Naive Bayes algorithm with different models
  - Multinomial
  - Binarized (boolean) multinomial
  - Bernoulli
- No external dependencies
- Ignores stop words
- [Additive smoothing](https://en.wikipedia.org/wiki/Additive_smoothing)
- [TF-IDF](https://en.wikipedia.org/wiki/Tf-idf)
- Optional keywords weighting
- Optional word [stemming](https://en.wikipedia.org/wiki/Stemming) via [Stemmer](https://github.com/fredwu/stemmer)

### Feature Matrix

|                    | Multinomial | Binarized multinomial | Bernoulli |
|--------------------|-------------|-----------------------|-----------|
| Stop words         | ✅          | ✅                    | ✅       |
| Additive smoothing | ✅          | ✅                    |          |
| TF-IDF             | ✅          |                       |          |
| Keywords weighting | ✅          |                       |          |
| Stemming           | ✅          | ✅                    | ✅       |

## Usage

```elixir
bayes = SimpleBayes.init()
        |> SimpleBayes.train(:apple, "red sweet")
        |> SimpleBayes.train(:apple, "green", weight: 0.5)
        |> SimpleBayes.train(:apple, "round", weight: 2)
        |> SimpleBayes.train(:banana, "sweet")
        |> SimpleBayes.train(:banana, "green", weight: 0.5)
        |> SimpleBayes.train(:banana, "yellow long", weight: 2)
        |> SimpleBayes.train(:orange, "red")
        |> SimpleBayes.train(:orange, "yellow sweet", weight: 0.5)
        |> SimpleBayes.train(:orange, "round", weight: 2)

bayes |> SimpleBayes.classify_one("Maybe green maybe red but definitely round and sweet.")
# => :apple

bayes |> SimpleBayes.classify("Maybe green maybe red but definitely round and sweet.")
# => [
#   apple:  0.18519202529366116,
#   orange: 0.14447781772131096,
#   banana: 0.10123406763124557
# ]
```

With and without word stemming:

```elixir
SimpleBayes.init()
|> SimpleBayes.train(:apple, "buying apple")
|> SimpleBayes.train(:banana, "buy banana")
|> SimpleBayes.classify("buy apple")
# => [
#   banana: 0.05719389206673358,
#   apple: 0.05719389206673358
# ]

SimpleBayes.init(stem: true)
|> SimpleBayes.train(:apple, "buying apple")
|> SimpleBayes.train(:banana, "buy banana")
|> SimpleBayes.classify("buy apple")
# => [
#   apple: 0.18096114003107086,
#   banana: 0.15054767928902865
# ]
```

### Configuration (Optional)

For application wide configuration, in your application's `config/config.exs`:

```elixir
config :simple_bayes, model: :multinomial
config :simple_bayes, default_weight: 1
config :simple_bayes, smoothing: 0.001
config :simple_bayes, stem: false
config :simple_bayes, stop_words: ~w(
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
```

Alternatively, you may pass in the configuration options when you initialise:

```elixir
SimpleBayes.init(
  model:          :multinomial,
  default_weight: 1,
  smoothing:      0.001,
  stem:           false,
  stop_words:     []
)
```

Available options for `:model` are:

- `:multinomial` (default)
- `:binarized_multinomial`
- `:bernoulli`

## Changelog

Please see [CHANGELOG.md](CHANGELOG.md).

## License

Licensed under [MIT](http://fredwu.mit-license.org/).
