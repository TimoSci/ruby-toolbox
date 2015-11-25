
module Enumerable

  #Extentions for mixed data structures consisting of nested Arrays and Hashes

  # Like #each, but it loops through every Array and Hash in a nested Array/Hash data structure
  def each_deep
    deep =->(x){
      if not Enumerable === x
        yield x
      else
        x.each do |element|
          case x
          when Array
            deep.call(element)
          when Hash
            deep.call(element[1])
          end
        end
      end
    }
    deep.call(self)
  end


  # Like #map, but it maps every element in a nested Hash/Array data structure.
  # For an Array is maps the elements and for a Hash it maps the values
  def map_deep
    deep =->(x){
      if not Enumerable === x
        yield x
      else
          case x
          when Array
            x.map{|e| deep.call(e)}
          when Hash
            h={}
            x.each do |key,value|
              h[key] = deep.call(value)
            end
            h
          end
      end
    }
    deep.call(self)
  end

  # Like #flatten, but it also flattens Hashes inside a nested Hash/Array data structure.
  # The values of Hashes are pushed into the output array and the keys are discarded
  def trample
    out = []
    self.each_deep{|x| out << x}
    out
  end

end



 ##DEMO
 #data_structure = [1,2,[31,32],4,[{a:51,b:52,c:[531,532,[5331,5332]]},{a:54,b:55}]]

 #data_structure.each_deep{|x| puts x}
 #puts data_structure.map_deep{|x| x*10}.inspect
 #puts data_structure.trample.inspect
