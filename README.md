# ruby-toolbox

My personal ruby swiss army knife

This reposity contains methods, modules, and classes that I have created for my own usage.

##How to use deepop.rb

Save the file deepop.rb in the same folder as you application, then include it using `require_relative 'deepop'`` and your Enumerable class
is monkey patched and ready to go

Usage examples:

```
my_array = [1,[2,3],{a:1,b:2}]; puts array.trample`
my_hash = {a:1,b:[2,3],c:[5,[6,7]]}; puts hash.trample`
```
