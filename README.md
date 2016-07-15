# Simple Bayes [![Travis](https://img.shields.io/travis/fredwu/simple_bayes.svg?maxAge=2592000)](https://travis-ci.org/fredwu/simple_bayes) [![Hex.pm](https://img.shields.io/hexpm/v/simple_bayes.svg?maxAge=2592000)](https://hex.pm/packages/simple_bayes)

A Simple Bayes (a.k.a. [Naive Bayes](https://en.wikipedia.org/wiki/Naive_Bayes_classifier)) implementation in Elixir.

## Features

- [x] Naive Bayes algorithm
- [x] No external dependencies
- [x] Optional keywords weighting
- [x] Ignores English stop words
- [x] [Additive smoothing](https://en.wikipedia.org/wiki/Additive_smoothing)
- [ ] [TF-IDF](https://en.wikipedia.org/wiki/Tf-idf)

## API

```elixir
bayes = SimpleBayes.init
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
#   apple:  -15.492915521902894,
#   orange: -18.544068044350276,
#   banana: -21.706795341847975
# ]
```

## License

Licensed under [MIT](http://fredwu.mit-license.org/)
