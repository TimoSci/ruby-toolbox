#!/usr/bin/env ruby

require 'pry'
require './hash_functions.rb'
# require 'benchmark'
require 'prime'

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



class RubinKarp

  # The Rubin-Karp algorithm is a string search algorithm that can be used to find matching occrences of <pattern> in <text>.

  include HashFunctions

  attr_reader :pattern, :text, :pl, :tl, :p_hash, :recursion

  def initialize(pattern,text,**options)
    # @pattern = pattern.chars.map(&:ord)
    # @text = text.chars.map(&:ord)
    @pattern = pattern
    @text = text

    @pl = pattern.size
    @tl = text.size

    n_false_alarms = 1000
    # params = generate_hash_parameters(n_false_alarms,@pl,@tl)
    p = options[:prime] || next_prime(pl*tl*n_false_alarms)
    x = options[:x] || rand(1...p)
    # x = p/2
    @p_hash = polyhash_string(prime:p,x:x)
    @recursion = polyhash_recursive( pattern_size: @pl, text: @text, prime: p, x: x)
  end
  #
  # def generate_hash_parameters(n_false_alarms,pattern_size,text_size)
  #   params = {}
  #   params[:prime] =  next_prime(pattern_size*text_size*n_false_alarms)
  #   pp params[:prime]
  #   params[:x] = rand(1...p)
  #   params
  # end

  def precompute_substring_hash

    hashes = []
    subtext = text[-pl..-1]
    hash = p_hash.(subtext)
    hashes << hash

    (tl-pl-1).downto(0) do |i|
      hash = recursion.(i,hash)
      hashes << hash
    end

    hashes.reverse

  end

  def find_fast
    occurences = []
    hashes = precompute_substring_hash
    pattern_hash = p_hash.(pattern)
    hashes.each.with_index do |hash,i|
       if pattern_hash == hash
         if pattern == text[i...(i+pl)]
           occurences << i
         end
       end
    end
    occurences
  end

end
