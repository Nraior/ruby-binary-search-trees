require_relative 'node'
class Tree
  def initalize(array)
    @root = build_tree
  end

  def build_tree(array)
    sorted_array = array.sort
    mid = array.length / 2
    @root = Node.new
  end
end
