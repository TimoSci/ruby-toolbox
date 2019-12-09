require_relative '../longest_common_substring.rb'

require 'rspec'
require 'pry'
require 'benchmark'


  # load Dir["./*.rb"].select{|f| f !~ /spec/}[0]

# class Wrapper
#   # load '.rb'
#   load Dir["./*.rb"].select{|f| f !~ /spec/}[0]
#
# end


describe LongestCommonSubstring do


  it 'should compute the correct answer for trivial values' do

    pair = described_class.new("a","a")
    expect(pair.longest_common_substring).to eq "a"
    expect(pair.longest_size).to eq 1
    expect(pair.binary_search).to eq [1,[0,0]]

    pair = described_class.new("a","b")
    expect(pair.longest_common_substring).to eq ""
    expect(pair.longest_size).to eq 0

    pair = described_class.new("a","aa")
    expect(pair.longest_size).to eq 1
    expect(pair.binary_search).to eq [1,[0,0]]

    pair = described_class.new("aa","a")
    expect(pair.longest_size).to eq 1
    expect(pair.binary_search).to eq [1,[0,0]]

    pair = described_class.new("ab","aa")
    expect(pair.longest_size).to eq 1

    pair = described_class.new("aba","baa")
    expect(pair.longest_size).to eq 2

    pair = described_class.new("aacbbbc","abbba")
    expect(pair.longest_size).to eq 3
    expect(pair.binary_search).to eq [3,[3,1]]
  end

  it 'should find the longest common substring for known values' do
    pair = described_class.new("awfwieuhfhelloworldefwfwe","egwhelloworldiosefwoehfweruhgwoeghwoegfjw")
    expect(pair.longest_common_substring).to eq "helloworld"
    pair = described_class.new("awfwieuhfhelloworldefwaaaaaaaaaaafwe","egwhelloworldioseaaaaaaaaaaaaaaifwoehfweruhgwoeghwoegfjw")
    expect(pair.longest_common_substring).to eq "aaaaaaaaaaa"
  end

  it 'should pass a stress test comparing with naive results' do

    alphabet = ('a'..'z').to_a

    def naive(*args)
      LongestCommonSubstring::Test.naive(*args)
    end

    20.times do
      a1 = Array.new(200){alphabet.to_a.sample}.join
      a2 = Array.new(200){alphabet.to_a.sample}.join

      pair = described_class.new(a1,a2)
      # pp pair.longest_common_substring
      size_naive = naive(a1,a2).size
      size_trial = pair.longest_size
      expect(size_trial).to eq size_naive
    end

    100.times do
      a1 = Array.new(rand(1..20)){alphabet.to_a.sample}.join
      a2 = Array.new(rand(1..20)){alphabet.to_a.sample}.join

      pair = described_class.new(a1,a2)
      size_naive = naive(a1,a2).size
      size_trial = pair.longest_size
      # pp [a1,a2]
      expect(size_trial).to eq size_naive
    end

    10.times do
      p = Array.new(rand(1..200)){alphabet.to_a.sample}.join

      a = Array.new(rand(1..200)){alphabet.to_a.sample}.join
      b = Array.new(rand(1..200)){alphabet.to_a.sample}.join
      a1 = a+p+b

      a = Array.new(rand(1..200)){alphabet.to_a.sample}.join
      b = Array.new(rand(1..200)){alphabet.to_a.sample}.join
      a2 = a+p+b

      pair = described_class.new(a1,a2)
      size_naive = naive(a1,a2).size
      size_trial = pair.longest_size
      # pp size_trial
      expect(size_trial).to eq size_naive
    end

  end

  it 'should pass a stress test for generated substrings' do

    10.times do

    def generate(n)
      alphabet = 'a'..'z'
      Array.new(rand(n)){alphabet.to_a.sample}.join
    end

    known_size = rand(1000..10000)

    p = "A"*known_size
    p1 = "XXXXXXX"+p+"XXXXXXXXX"
    k1 = generate(10000)
    s1 = k1+p1+generate(10000)

    p2 = "ZZZZZZZ"+p+"ZZZZZZZZZ"
    k2 = generate(10000)
    s2 = k2+p2+generate(10000)

    s = LongestCommonSubstring.new(s1,s2)
    size, pos = s.binary_search
    expect(size).to eq known_size
    # expect(pos[0]).to eq k1.size
    # expect(pos[1]).to eq k2.size
    end

  end


end
