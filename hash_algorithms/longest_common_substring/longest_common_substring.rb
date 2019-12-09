require_relative '../rubin_karp/rubin_karp.rb'

class LongestCommonSubstring

  attr_reader :smaller, :bigger, :left, :right
  attr_accessor :hash_params

  def initialize(left,right)
    @hash_rounds = 2
    @hash_params ={}
    @left,@right = left,right
    # @smaller,@bigger = [left,right].sort_by(&:size)
    if left > right
      @smaller,@bigger = right,left
    else
      @smaller,@bigger = left,right
    end
  end

  def set_hash_params
    hash_params = RubinKarp.generate_hash_parameters(10,smaller.size,bigger.size)
  end

  def precompute_substring_hashes(pattern_size)
    hash_params = set_hash_params
    [smaller,bigger].map do |substring|
      RubinKarpSearchableText.new(substring,pattern_size,hash_params).precompute_substring_hashes
    end
  end

  def precompute_substring_hashes_multi(pattern_size,rounds)
    Array.new(rounds){precompute_substring_hashes(pattern_size)}
  end

  def match?(pattern_size)
    hashes_left, hashes_right = precompute_substring_hashes(pattern_size)
    table = create_hash_table(hashes_left)
    hashes_right.each_with_index do |hash,j|
       if (i=table[hash])
          if smaller[i...(i+pattern_size)] == bigger[j...(j+pattern_size)]
             return [i,j]
          end
       end
    end
    return false
  end

  def create_hash_table(hashes)
    hashes.map.with_index{|h,i| [h,i]}.to_h
  end

  #===


  def binary_search
    size,position = _binary_search
    size = 0 if size < 0
    position = [0,0] if size == 0
    position = position.reverse if left > right
    [size,position]
  end

  def _binary_search
    range = get_initial_range(smaller,bigger)

    if (position=match?(range.last))
      return [range.last,position]
    end

    best_position = 0
    bs = ->(range){
      return range.first-1 if range.size <= 1
      trial_length = range.first + (range.last-range.first)/2
      position = match?(trial_length)
      if position
        best_position = position
        bs.((trial_length+1)..range.last)
      else
        bs.(range.first..trial_length)
      end
    }
    size = bs.(range)
    [size,best_position]
  end

  def get_initial_range(left,right)
    longest_possible = [left.size,right.size].min
    length = 1
    while length < longest_possible && match?(length)
     length *= 2
    end
    length = longest_possible if length > longest_possible
    ((length/2)..(length))
  end

  def longest_size
    size, pos = binary_search
    size
  end


  def longest_common_substring
    size, pos = binary_search
    pos = pos.first
    smaller[pos...(size+pos)]
  end

end



class LongestCommonSubstring::Test

  def self.naive(a,b)
    longest = ""
    a,b = [a,b].sort_by(&:size)
    return "" if a.size == 0
    (1..(a.size)).each do |length|
      # binding.pry
      subtrings_b = substrings(b,length)
      # pp subtrings_b
      substrings(a,length).each do |sa|
        longest = sa if subtrings_b.include? sa
      end
    end
    longest
  end

  def self.substrings(a,l)
    (0..(a.size-l)).map do |i|
      a[i...(l+i)]
    end
  end
end
