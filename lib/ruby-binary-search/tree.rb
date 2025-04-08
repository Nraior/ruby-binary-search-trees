require_relative 'node'
class Tree
  attr_reader :root

  def initialize(array)
    sorted_array = array.uniq.sort
    @root = build_tree(sorted_array, 0, sorted_array.length - 1)
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
    where_to_insert = find_for_insert(@root, value)
    if value > where_to_insert.data
      where_to_insert.right = Node.new(value)
    else
      where_to_insert.left = Node.new(value)
    end
  end

  def find_for_insert(node, value)
    if value < node.data
      return find_for_insert(node.left, value) unless node.left.nil?
    else
      return find_for_insert(node.right, value) unless node.right.nil?
    end
    node
  end

  def find(node, value, parent = nil)
    if value == node.data
      # Do nothing
    elsif value < node.data
      return find(node.left, value, node) unless node.left.nil?
    else
      return find(node.right, value, node) unless node.right.nil?
    end

    return { node: nil, parent: nil } if node.data != value

    { node: node, parent: parent }
  end

  def delete(value, start_node = @root)
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
  end

  def update_parent_node_leaf_conditionally(parent, new_value, value)
    parent.left = new_value if parent.left_contains_value?(value)
    parent.right = new_value if parent.right_contains_value?(value)
  end

  def succ(node)
    return succ(node.left) if node.left

    node
  end

  def level_order(&block)
    return unless block_given?

    queue = []
    level_check(@root, queue, &block)
  end

  def level_check(node, queue, &block)
    return if node.nil?

    queue.push(node.left) unless node&.left.nil?
    queue.push(node.right) unless node&.right.nil?

    next_node = queue.shift

    yield(node.data)

    level_check(next_node, queue, &block)
  end

  def preorder(node = @root, &block)
    return if node.nil? || !block_given?

    yield(node.data)
    preorder(node.left, &block)
    preorder(node.right, &block)
  end

  def inorder(node = @root, &block)
    return if node.nil? || !block_given?

    inorder(node.left, &block)
    yield(node.data)
    inorder(node.right, &block)
  end

  def postorder(node = @root, &block)
    return if node.nil? || !block_given?

    postorder(node.left, &block)
    postorder(node.right, &block)
    yield(node.data)
  end

  def height(value)
    start_point = find(@root, value)[:node]
    return 0 if start_point.nil?

    height = search_height(value, start_point)
  end

  def search_height(value, current_node)
    return 0 if current_node.nil?

    left = 1 + search_height(value, current_node&.left)
    right = 1 + search_height(value, current_node&.right)

    [left, right].max
  end

  def depth(value)
    depth = search_depth(@root, value)
    p depth
  end

  def search_depth(node, value)
    # p node.data unless node.nil?
    return nil if node.nil?
    return 1 if node.data == value

    left =  search_depth(node.left, value)
    right = search_depth(node.right, value)

    left += 1 unless left.nil?
    right += 1 unless right.nil?
    [left, right].compact.max
  end

  def balanced?
    balanced_walk(@root)
  end

  def balanced_walk(node)
    return 0 if node.nil?
    return 0 if node.left.nil? && node.right.nil?

    if node.right.nil?
      total = 1 + balanced_walk(node.left)
      return false if total >= 2

      return total

    elsif node.left.nil?
      total = 1 + balanced_walk(node.right)
      return false if total >= 2

      return total

    else
      l = balanced_walk(node.left)
      r = balanced_walk(node.right)

      return false if l == false || r == false
    end
    true
  end
end
