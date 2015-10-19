# This method performs a block or method on every element of a nested array

class Array


def deepop(*method,&block)
  callable = method
  callable ||= block
  callable ||= ->(x){x}
 
  inner_deepop= ->(x){
    if x.kind_of? Array
      x.inject([]){|result,element| result << inner_deepop.call(element)}
    else
      return callable.call(x)
    end
  }

  inner_deepop.call(self)

end



 def dodeep(&block)
   @block = block
   def inner_deepop(x)
     if x.class == Array   
       inner_array = [] 
       x.each do |element|
        inner_array << inner_deepop(element)
       end
       return inner_array
     else
       return @block.call(x)
     end
   end
   inner_deepop(self)
 end

end




# Examples

a = [1,2,3,5,[7,9],[11,13,15,[21,23]]]

def hello(x)
"hello"+x.to_s
end

h = method(:hello)

p a.deepop(h)
p ""
p a.deepop{|x| x*100}
