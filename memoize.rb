module Memoize

  def attr_lazy(name,&block)
    define_method(name) do
      memo_name = "@#{name.to_s.delete('?')}"
      instance_variable_set(memo_name,instance_eval(&block)) if !instance_variable_defined? memo_name
      send( define_singleton_method(name){ instance_variable_get memo_name} )
    end
  end
  
end
