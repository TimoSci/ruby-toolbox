require_relative '../rubin_karp.rb'

class Wrapper
  include Test
end
w = Wrapper.new


describe RubinKarp do

    it 'should find the correct positions in trivial cases' do
      # p = ""
      # t = ""
      # state = described_class.new(p,t)
      # expect(state.find_fast).to eq [0]
      #
      # p = "a"
      # t = ""
      # state = described_class.new(p,t)
      # expect(state.find_fast).to eq []

      p = "a"
      t = "a"
      state = described_class.new(p,t)
      expect(state.find_fast).to eq [0]

      p = "a"
      t = "b"
      state = described_class.new(p,t)
      expect(state.find_fast).to eq []
    end

    it 'should find the positions for known substrings' do
      p = "aba"
      t = "abacaba"
      state = described_class.new(p,t)
      expect(state.find_fast).to eq [0,4]

      p = "Test"
      t = "testTesttesT"
      state = described_class.new(p,t)
      expect(state.find_fast).to eq [4]

      p = "aaaaa"
      t = "baaaaaaa"
      state = described_class.new(p,t)
      expect(state.find_fast).to eq [1,2,3]
    end

    it 'should find the positions for test data' do

      p=nil
      t=nil
      File.open("./tests/06") do |file|
        p = file.readline.chop
        t = file.readline.chop
      end

      answer= nil
      File.open("./tests/06.a") do |file|
        answer = file.readline.chop.split(/\s/).map(&:to_i)
      end

      state = described_class.new(p,t)
      expect(state.find_fast).to eq answer
    end

    it 'should pass a stress test' do

      10.times do
        text = Array.new(10000){('a'..'z').to_a.sample}.join
        pattern = Array.new(2){('a'..'z').to_a.sample}.join
        state = described_class.new(pattern,text)
        expect(state.find_fast).to eq  w.find_naive(pattern,text)
      end

      20.times do
        text1 = Array.new(rand(10000)){('a'..'z').to_a.sample}.join
        text2 = Array.new(rand(10000)){('a'..'z').to_a.sample}.join
        pattern = Array.new(rand(100)){('a'..'z').to_a.sample}.join
        text = text1+pattern+text2
        state = described_class.new(pattern,text)
        expect(state.find_fast).to eq  w.find_naive(pattern,text)
      end

    end

end
