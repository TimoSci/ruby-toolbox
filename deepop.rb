require 'pry'
module Enumerable

  #Extentions for mixed data structures consisting of nested Arrays and Hashes

  # Generalized sender of iterator methods to Enumerable trees.
  def deep_send(iterator)
    deep =->(x){
      case x
      when Enumerable
        x.send(iterator){|e| deep.(e)}
      else
        yield x
      end
    }
    deep.(self)

  end

  # Like #each, but it loops through every Array and Hash in a nested Array/Hash data structure.
  # For Hashes it iterates through the keys and for Arrays it iterates through the values.

  def each_deep
    self.deep_send("each_values"){|x| yield x}
  end

  # Like #map, but it maps every element in a nested Hash/Array data structure.
  # For an Array is maps the elements and for a Hash it maps the values

  def map_deep
    self.deep_send("map_values"){|x| yield x}
  end

  # A #map that works both for Arrays and Hashes. For Hashes it keeps the original keys.
  def map_values
    case self
    when Array
      self.map{|x| yield x}
    when Hash
      self.map{|k,v| [k,(yield v)]}.to_h
    else
      nil
    end
  end

  # An #each that works both for Arrays and Hashes. For Hashes it iterates over the values.
  def each_values
    case self
    when Array
      self.each{|x| yield x}
    when Hash
      self.each{|_k,v| yield v}
    else
      nil
    end
  end

  # Selects a hash of all Hash sub-branches based on the key
  # Returns an array of the values of found branches
  #
  def select_branches_by_key
    branches = []
    deep =->(x){
      case x
      when Array
        x.each{|e| deep.(e)}
      when Hash
        x.each{|k,v| deep.(v) }
        selected =  x.select{|k,v| yield k}
        branches |= selected.values if selected != {}
      end
    }
    deep.(self)
    branches 
  end

  # Like #flatten, but it also flattens Hashes inside a nested Hash/Array data structure.
  # The values of Hashes are pushed into the output array and the keys are discarded
  def trample
    out = []
    self.each_deep{|x| out << x}
    out
  end

  # Like #include, but it searches through all Array elements and Hash values.
  def include_deep?(input)
    self.each_deep{|x| return true if x == input}
    return false
  end


end



 # #DEMO
#  data_structure = [1,2,[31,32],4,[{a:51,b:52,c:[531,532,[5331,5332]]},{a:54,b:55}],6]
 # puts "original data structure:"
 # puts data_structure.inspect
 # puts
 # puts "puts #each iteratee of data structure:"
 # data_structure.each_deep{|x| puts x}
 # puts
 # puts "mapped data structure after applying *10"
 # puts data_structure.map_deep{|x| x.to_s.to_i*10}.inspect
 # puts
 # puts "flattened data structure:"
 # puts data_structure.flatten.inspect
 # puts
 # puts "trampled data structure"
 # puts data_structure.trample.inspect
 # puts
 # puts "find? 5332 somwhere in data structure"
 # puts data_structure.include_deep?(5332)
