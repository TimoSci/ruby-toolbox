require 'rspec'
require 'pry'

require_relative '../splay_tree.rb'

describe SplayTreeVertex do

  it 'should preserve a BST for a known example after small_rotation operations' do

      vertex = SplayTreeVertex.new(4)
      [2,5,1,3,7,6].each{|i| vertex.insert(i)}

      arr =  vertex.to_inorder

      arr.each do |i|
        v = vertex.find(i)
        if v.parent
          v.small_rotation
          vertex = vertex.root
        end
        # binding.pry if vertex.to_inorder != arr
        expect(vertex.to_inorder).to eq arr
      end


  end



  it 'should pass a stress test for small_rotation operations' do
    stress_test(:small_rotation)
  end

  it 'should pass a stress test for zig_zig operations' do
    stress_test(:zig_zig)
  end

  it 'should pass a stress test for zig_zag operations' do
    stress_test(:zig_zag)
  end

  it 'should pass a stress test for big_rotation operations' do
    stress_test(:big_rotation,condition: ->(v){v.parent && v.parent.parent})
  end

  it 'should pass a stress test for splay operations' do
    stress_test(:splay)
  end

  it 'should pass a stress test for splay_find operations' do
    stress_test(:splay_find, arguments: ->(_,k){ [rand(k)] } )
  end

  it 'should pass a stress test for splay_insert operations' do
    stress_test_insert
  end

  it 'should pass a stress test for splay_delete operations' do
    stress_test_delete
  end

end


def stress_test(method,condition: ->(v){v.parent},arguments:nil)

  tree_size = 100
  sample_space_size = 200
  l = 100
  j = 100

  l.times do
    vertex = generate_random_tree(tree_size,sample_space_size)

    arr =  vertex.to_inorder
    # pp vertex.height
    expect(vertex.is_bst?).to be true

    j.times do
      i = arr.sample
    # arr.each do |i|
      v = vertex.find(i)
      if condition.(v)
        old_pre = vertex.to_preorder
        old_post = vertex.to_postorder

        args = arguments.(tree_size,sample_space_size) if arguments
        v.send(method,*args)
        vertex = vertex.root

        new_pre = vertex.to_preorder
        new_post = vertex.to_postorder
        expect(new_pre).not_to eq old_pre
        expect(new_post).not_to eq old_post
        expect(vertex.to_inorder).to eq arr
      end
    end

   end

end


def stress_test_insert

  tree_size = 100
  sample_space_size = 200
  l = 100
  j = 100

  l.times do
    vertex = generate_random_tree(tree_size,sample_space_size)

    samples =  vertex.to_inorder.shuffle!

    j.times do
      i = samples.pop+sample_space_size+1

      old_pre = vertex.to_preorder
      old_post = vertex.to_postorder
      old_in = vertex.to_inorder

      vertex = vertex.splay_insert(i)

      new_pre = vertex.to_preorder
      new_post = vertex.to_postorder
      new_in = vertex.to_inorder

      expect(new_pre).not_to eq old_pre
      expect(new_post).not_to eq old_post
      expect(new_in).to eq (old_in + [i]).sort

    end

   end

end



def stress_test_delete

  tree_size = 100
  sample_space_size = 200
  l = 100
  j = 100

  l.times do
    vertex = generate_random_tree(tree_size,sample_space_size)

    samples =  vertex.to_inorder.shuffle!

    j.times do
      unless vertex.leaf? && !vertex.parent
        i = samples.pop+sample_space_size+1

        v = vertex.find(i)
        key = v.key

        old_pre = vertex.to_preorder
        old_post = vertex.to_postorder
        old_in = vertex.to_inorder

        vertex = v.splay_delete
        pp vertex.size

        new_pre = vertex.to_preorder
        new_post = vertex.to_postorder
        new_in = vertex.to_inorder

        expect(new_pre).not_to eq old_pre
        expect(new_post).not_to eq old_post
        expect(new_in).to eq (old_in - [key]).sort
      end
    end

   end

end








def generate_random_tree(tree_size,sample_space_size)
  set = (1..sample_space_size).to_a
  set.shuffle!
  vertex = SplayTreeVertex.new(set.pop)

  until set.size < sample_space_size - tree_size
    x = set.pop
    vertex.insert(x)
  end
  vertex
end
