# Algorithms related to non-cryptographic hash Functions

## RubinKarp

The Rubin-Karp algorithm is based on polynomial hash functions. It can be used to search for a know substring in a text. It is faster than the naive algorithm, ie. going to every position and comparing every subsequent element with every element in
the substring.

### RubinKarp#find_fast

This method returns an array of positions (indexes) in the text string where the pattern has been found.

Usage example:

```
text = "xzxzxzxzxzxhellozxzxxxxzxzhellozxzx"
pattern = "hello"
search_case = RubinKarp.new(pattern,text)
search_case.find_fast
```


## HashFunctions

Polynomial hash functions which can be used as basic building blocks in Hash Tables and other algorithms.
