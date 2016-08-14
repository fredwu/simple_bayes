# Simple Bayes [![Travis](https://img.shields.io/travis/fredwu/simple_bayes.svg)](https://travis-ci.org/fredwu/simple_bayes) [![Hex.pm](https://img.shields.io/hexpm/v/simple_bayes.svg)](https://hex.pm/packages/simple_bayes)

A [Naive Bayes](https://en.wikipedia.org/wiki/Naive_Bayes_classifier) machine learning implementation in Elixir.

> In machine learning, __naive Bayes classifiers__ are a family of simple probabilistic classifiers based on applying Bayes' theorem with strong (naive) independence assumptions between the features.

> Naive Bayes has been studied extensively since the 1950s. It was introduced under a different name into the text retrieval community in the early 1960s, and remains a popular (baseline) method for text categorization, the problem of judging documents as belonging to one category or the other (such as spam or legitimate, sports or politics, etc.) with word frequencies as the features. With appropriate preprocessing, it is competitive in this domain with more advanced methods including support vector machines. It also finds application in automatic medical diagnosis.

> Naive Bayes classifiers are highly scalable, requiring a number of parameters linear in the number of variables (features/predictors) in a learning problem. Maximum-likelihood training can be done by evaluating a closed-form expression, which takes linear time, rather than by expensive iterative approximation as used for many other types of classifiers. - [Wikipedia](https://en.wikipedia.org/wiki/Naive_Bayes_classifier)

## Features

- Naive Bayes algorithm with different models
  - Multinomial
  - Binarized (boolean) multinomial
  - Bernoulli
- Multiple storage options
  - In-memory (default)
  - File system
  - [Dets](http://erlang.org/doc/man/dets.html) (Disk-based Erlang Term Storage)
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

Install by adding `:simple_bayes` and optionally `:stemmer` to `deps` in your
`mix.exs`:

```elixir
defp deps do
  [ {:simple_bayes, "~> 0.10.0"},
    {:stemmer, "~> 1.0"} # Optional, if you want to use stemming
  ]
end
```

Ensure `:simple_bayes` and optionally `:stemmer` are started before your
application:

```elixir
def application do
  [ applications: [
      :logger,
      :simple_bayes,
      :stemmer # Optional, if you want to use stemming
    ]
  ]
end
```


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

bayes |> SimpleBayes.classify("Maybe green maybe red but definitely round and sweet.", top: 2)
# => [
#   apple:  0.18519202529366116,
#   orange: 0.14447781772131096,
# ]
```

With and without word stemming (requires a stem function, we recommend [Stemmer](https://github.com/fredwu/stemmer)):

```elixir
SimpleBayes.init()
|> SimpleBayes.train(:apple, "buying apple")
|> SimpleBayes.train(:banana, "buy banana")
|> SimpleBayes.classify("buy apple")
# => [
#   banana: 0.05719389206673358,
#   apple: 0.05719389206673358
# ]

SimpleBayes.init(stem: &Stemmer.stem/1) # Or any other stemming function
|> SimpleBayes.train(:apple, "buying apple")
|> SimpleBayes.train(:banana, "buy banana")
|> SimpleBayes.classify("buy apple")
# => [
#   apple: 0.18096114003107086,
#   banana: 0.15054767928902865
# ]
```

## Configuration (Optional)

For application wide configuration, in your application's `config/config.exs`:

```elixir
config :simple_bayes, model: :multinomial
config :simple_bayes, storage: :memory
config :simple_bayes, default_weight: 1
config :simple_bayes, smoothing: 0
config :simple_bayes, stem: false # or a stemming function
config :simple_bayes, top: nil
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
  storage:        :memory,
  default_weight: 1,
  smoothing:      0,
  stem:           false, # or a stemming function
  top:            nil,
  stop_words:     []
)
```

### Available options for `:model` are:

- `:multinomial` (default)
- `:binarized_multinomial`
- `:bernoulli`

### Available options for `:storage` are:

- `:memory` (default, can also be used by any database, [see below](#in-memory-save2-load1-and-the-encoded_data-option) for more details)
- `:file_system`
- `:dets`

Storage options have extra configurations:

#### Memory

- `:namespace` - optional, it's only useful when you want to `load` by the namespace

#### File System

- `:file_path`

#### Dets

- `:file_path`

#### File System vs Dets

File system encodes and decodes data using base64, whereas Dets is a native Erlang library. Performance wise file system with base64 tends to be faster with less data, and Dets faster with more data. YMMV, please do your own comparison.

#### Configuration Examples

```elixir
# application-wide configuration:
config :simple_bayes, storage: :file_system
config :simple_bayes, file_path: "path/to/the/file.txt"

# per-initialization configuration:
SimpleBayes.init(
  storage: :file_system,
  file_path: "path/to/the/file.txt"
)
```

#### Storage Usage

```elixir
opts = [
  storage:   :file_system,
  file_path: "test/temp/file_sysmte_test.txt"
]

SimpleBayes.init(opts)
|> SimpleBayes.train(:apple, "red sweet")
|> SimpleBayes.train(:apple, "green", weight: 0.5)
|> SimpleBayes.train(:apple, "round", weight: 2)
|> SimpleBayes.train(:banana, "sweet")
|> SimpleBayes.save()

SimpleBayes.load(opts)
|> SimpleBayes.train(:banana, "green", weight: 0.5)
|> SimpleBayes.train(:banana, "yellow long", weight: 2)
|> SimpleBayes.train(:orange, "red")
|> SimpleBayes.train(:orange, "yellow sweet", weight: 0.5)
|> SimpleBayes.train(:orange, "round", weight: 2)
|> SimpleBayes.save()

SimpleBayes.load(opts)
|> SimpleBayes.classify("Maybe green maybe red but definitely round and sweet")
```

#### In-memory `save/2`, `load/1` and the `encoded_data` option

Calling `SimpleBayes.save/2` is unnecessary for `:memory` storage. However, when using the in-memory storage, you are able to get the encoded data - this is useful if you would like to store the encoded data in your persistence of choice. For example:

```elixir
{:ok, _pid, encoded_data} = SimpleBayes.init()
|> SimpleBayes.train(:apple, "red sweet")
|> SimpleBayes.train(:apple, "green", weight: 0.5)
|> SimpleBayes.train(:apple, "round", weight: 2)
|> SimpleBayes.train(:banana, "sweet")
|> SimpleBayes.save()

# now store `encoded_data` in your database of choice
# once `encoded_data` is fetched again from the database, you are then able to:

SimpleBayes.load(encoded_data: encoded_data)
|> SimpleBayes.train(:banana, "green", weight: 0.5)
|> SimpleBayes.train(:banana, "yellow long", weight: 2)
|> SimpleBayes.train(:orange, "red")
|> SimpleBayes.train(:orange, "yellow sweet", weight: 0.5)
|> SimpleBayes.train(:orange, "round", weight: 2)
|> SimpleBayes.classify("Maybe green maybe red but definitely round and sweet")
```

## Changelog

Please see [CHANGELOG.md](CHANGELOG.md).

## License

Licensed under [MIT](http://fredwu.mit-license.org/).
