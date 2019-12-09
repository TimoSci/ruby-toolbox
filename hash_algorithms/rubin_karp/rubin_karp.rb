#!/usr/bin/env ruby
require_relative './hash_functions.rb'

require 'pry'
# require 'benchmark'
require 'prime'


class RubinKarpSearchableText

  # The Rubin-Karp algorithm is a string search algorithm that can be used to find matching occrences of <pattern> in <text>.

  include HashFunctions
  extend HashFunctions

  attr_reader :text, :pattern_size, :tl, :p_hash, :recursion

  def initialize(text,pattern_size,**options)
    @text = text

    @pattern_size = pattern_size
    @tl = text.size
    raise "pattern must be smaller than text" unless @pattern_size <= @tl

    n_false_alarms = options[:n_false_alarms] || 1000
    params = self.class.generate_hash_parameters(n_false_alarms,@pattern_size,@tl)
    p = options[:prime] || params[:prime]
    x = options[:x] || params[:x]
    # x = p/2
    # pp [p,x]
    @p_hash = polyhash_string(prime:p,x:x)
    @recursion = polyhash_recursive( pattern_size: @pattern_size, text: @text, prime: p, x: x)
  end

  #===
  def self.generate_hash_parameters(n_false_alarms,pattern_size,text_size)
    params = {}
    params[:prime] = [1000000007,1000000009,1000001011,1000010029].sample # magic primes seems faster
    # params[:prime] =  next_prime(pattern_size*text_size*n_false_alarms)
    params[:x] = rand(1...params[:prime])
    params
  end
  #===


  def precompute_substring_hashes
    hashes = []
    subtext = text[-pattern_size..-1]
    hash = p_hash.(subtext)
    hashes << hash

    (tl-pattern_size-1).downto(0) do |i|
      hash = recursion.(i,hash)
      hashes << hash
    end

    hashes.reverse

  end

  def find_fast(pattern)
    occurences = []
    hashes = precompute_substring_hashes
    pattern_hash = p_hash.(pattern)
    hashes.each.with_index do |hash,i|
      if pattern_hash == hash
        if pattern == text[i...(i+pattern_size)]
          occurences << i
        end
      end
    end
    occurences
  end

end

class RubinKarp < RubinKarpSearchableText
  attr_reader :pattern

  def initialize(pattern,text,**options)
    @pattern = pattern
    super(text,pattern.size,options)
  end

  def find_fast
    super(pattern)
  end
end


module Test
  def find_naive(pattern,text)
    t = text.size
    p = pattern.size
    occurences = []
    (0..(t-p)).each do |i|
      occurences << i if text[i...(i+p)] == pattern
    end
    occurences
  end
end
