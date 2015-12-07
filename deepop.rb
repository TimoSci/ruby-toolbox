
module Enumerable

  #Extentions for mixed data structures consisting of nested Arrays and Hashes


  # Like #each, but it loops through every Array and Hash in a nested Array/Hash data structure
  def each_deep
    deep =->(x){
      if Enumerable === x
        x.each do |element|
          case x
          when Array
            deep.(element)
          when Hash
            deep.(element[1])
          end
        end
      else
        yield x
      end
    }
    deep.(self)
  end


  # Like #map, but it maps every element in a nested Hash/Array data structure.
  # For an Array is maps the elements and for a Hash it maps the values
  def map_deep
    deep =->(x){
      case x
      when Enumerable
        x.map_values{|e| deep.(e)}
      else
        yield x
      end
    }
    deep.(self)
  end

  # A #map that works both for Arrays and Hashes. For Hashes it keeps the original keys.
  def map_values
    case self
    when Array
      self.map{|x| yield x}
    when Hash
      self.merge(self){|_k,v| yield v}
    else
      nil
    end
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



 #DEMO
 data_structure = [1,2,[31,32],4,[{a:51,b:52,c:[531,532,[5331,5332]]},{a:54,b:55}]]

 data_structure.each_deep{|x| puts x}
 puts data_structure.map_deep{|x| x*10}.inspect
 puts data_structure.trample.inspect
 puts data_structure.include_deep?(5332)
