
require_relative '../hash_functions.rb'
require 'pry'

class Wrapper
  include HashFunctions
end

describe Wrapper do

    w = described_class.new

    it 'should compute the correct hash for known integer values' do
       p=10
       x=2
       hash = w.polyhash_integer(prime:p,x:x)
       expect(hash.([])).to eq 0
       expect(hash.([0])).to eq 0
       expect(hash.([1])).to eq 1
       expect(hash.([1,0])).to eq 1
       expect(hash.([0,1])).to eq 2
       expect(hash.([1,1])).to eq 3
       expect(hash.([0,0,1])).to eq 4
       expect(hash.([0,0,0,0,1])).to eq 6
       expect(hash.([2])).to eq 2
       expect(hash.([0,2])).to eq 4
       expect(hash.([2])).to eq 2
       expect(hash.([0,0,0,2])).to eq 6
       expect(hash.([0,0,0,100])).to eq 0
       p=1e9
       x=10
       hash = w.polyhash_integer(prime:p,x:x)
       expect(hash.([1,2,3])).to eq 321
       expect(hash.([5,3,6,7,7])).to eq 77635
     end

     it 'should compute the correct hash for known string values' do
       p=10**9
       x=100
       hash = w.polyhash_string(prime:p,x:x)
       expect(hash.("")).to eq 0
       expect(hash.("a")).to eq 97
       expect(hash.("aa")).to eq 9797
     end

     it 'should compute the same value for a single hash and a recursive hash' do
       p=10000
       x=2
       hash = w.polyhash_string(prime:p,x:x)

       text = "abc"
       hash_recursive = w.polyhash_recursive(pattern_size:1,text:text,prime:p,x:p)
       first_hash = hash.("c")
       result = hash_recursive.(1,first_hash)
       expect(result).to eq hash.("b")
       result = hash_recursive.(0,result)
       expect(result).to eq hash.("a")

       # text = "bla"
       # first_hash = hash.("la")
       # hash_recursive = w.polyhash_recursive(pattern_size:2 ,text:text, prime:p, x:p)
       # result = hash_recursive.(1,first_hash)
       # expect(result).to eq hash.("bl")

     end

end
