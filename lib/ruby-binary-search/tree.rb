require_relative 'node'
class Tree
  attr_reader :root

  def initialize(array)
    sorted_array = array.uniq.sort
    @root = build_tree(sorted_array, 0, sorted_array.length - 1)
    pretty_print(@root)
  end

  def build_tree(array, start_index, end_index)
    return nil if start_index > end_index

    mid_index = start_index + ((end_index - start_index) / 2).floor

    Node.new(array[mid_index], build_tree(array, start_index, mid_index - 1),
             build_tree(array, mid_index + 1, end_index))
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
