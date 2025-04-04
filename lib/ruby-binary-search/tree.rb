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

  def insert(value)
    where_to_insert = find(@root, value)[:node]
    if value > where_to_insert.data
      where_to_insert.right = Node.new(value)
    else
      where_to_insert.left = Node.new(value)
    end

    pretty_print(@root)
  end

  def find(node, value, parent = nil)
    if value == node.data
      # Do nothing
    elsif value < node.data
      return find(node.left, value, node) unless node.left.nil?
    else
      return find(node.right, value, node) unless node.right.nil?
    end

    { node: node, parent: parent }
  end

  def delete_alt(value, start_node = @root)
    found = find(start_node, value)
    found_node = found[:node]
    found_parent = found[:parent]

    if found_node.left_child_exist? && found_node.right_child_exist?
      succ_node = succ(found_node.right)

      succ_parent = find(start_node, succ_node.data)[:parent]
      succ_parent.left = succ_node.left || succ_node.right if succ_parent.left == succ_node
      succ_parent.right = succ_node.left || succ_node.right if succ_parent.right == succ_node

      succ_node.data, found_node.data = found_node.data, succ_node.data
      if succ_parent.left&.data == value
        succ_parent.left = succ_node.left_child_exist? ? succ_node.left : succ_node.right
      end
      if succ_parent.right&.data == value
        succ_parent.right = succ_node.left_child_exist? ? succ_node.left : succ_node.right
      end
    elsif found_node.left_child_exist?
      update_parent_node_leaf_conditionally(found_parent, found_node.left, value)
    elsif found_node.right_child_exist?
      update_parent_node_leaf_conditionally(found_parent, found_node.right, value)
    else
      update_parent_node_leaf_conditionally(found_parent, nil, value)
    end
    pretty_print(@root)
  end

  def update_parent_node_leaf_conditionally(parent, new_value, value)
    parent.left = new_value if parent.left_contains_value?(value)
    parent.right = new_value if parent.right_contains_value?(value)
  end

  def succ(node)
    return succ(node.left) if node.left

    node
  end
end
