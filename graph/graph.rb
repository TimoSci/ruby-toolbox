
require 'pry'

class Graph < Array

  def initialize(n)
    super(n){|x| x = Vertex.new}
  end

  def read_edge(a,b)
    find(a) << find(b)
  end

  def find(k)
    self[k-1]
  end

  def reset_visited
    each{|v| v.visited = false}
  end

  def reset_visited
    each{|v| v.visited = false; v.pre = false, v.post = false}
  end

end

class DirectedGraph < Graph

  def read_edges(set)
    set.each do |pair|
      read_edge(*pair)
    end
  end

  # Check whether directed graph has a cycle
  #
  def cyclic?
    counter = 0
    each do |v|
      counter = v.explore_with_counter(counter){|_|}
    end
  end

end


# An undirected graph is represented as a directed graph with each edge as a pair of directed edges
#
class UndirectedGraph < Graph

  # Number of components in an undirected graph
  #
  def n_components
    n = 0
    each do |v|
      next if v.visited
      v.explore{|_|}
      n += 1
    end
    n
  end

  def read_edge_undirected(a,b)
    read_edge(a,b)
    read_edge(b,a)
  end

  def read_edges(set)
    set.each do |pair|
      read_edge_undirected(*pair)
    end
  end

end



class Vertex < Array

  def initialize
    @visited = false
  end
  attr_accessor :visited, :pre, :post

  def explore
    return if visited
    self.visited = true
    yield self
    self.each do |neighbor|
      neighbor.explore{|x| yield x}
    end
  end

  def explore_with_order
    explore_with_counter(0){|_|}
  end

  def explore_with_counter(counter)
    return counter if visited
    counter += 1
    self.pre = counter
    self.visited = true
    yield self
    self.each do |neighbor|
      counter = neighbor.explore_with_counter(counter){|x| yield x}
    end
    counter +=1
    self.post = counter
    return counter
  end

  def path?(other)
    explore do |v|
      return true if v == other
    end
    false
  end

end



# def read_graph
#   n,m = get_line
#   graph = Graph.new(n)
#   m.times do
#     a,b = get_line
#     graph.read_edge_undirected(a,b)
#   end
#   graph
# end
#
# def get_line
#   gets.split(/\s/).map(&:to_i)
# end
#
# def run
#   graph = read_graph
#   puts graph.n_components
# end
#
#
# run


#
#
#==============
#
# graph = UndirectedGraph.new(4)
# set =
# [
# [2,1],
# [4,3],
# [1,4],
# [2,4],
# [3,2]
# ]
# graph.read_edges(set)


# graph = Graph.new(4)
# set=
# [
# [1,2],
# [3,2]
# ]
# graph.read_edges(set)


graph = DirectedGraph.new(4)
set =
[
[1,2],
[4,1],
[2,3],
[3,1]
]
graph.read_edges(set)

v = graph.find(1)

binding.pry
