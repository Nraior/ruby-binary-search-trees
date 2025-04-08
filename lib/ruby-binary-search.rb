require_relative 'ruby-binary-search/tree'

data = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

tree = Tree.new(data)

# tree.insert(15)
# tree.insert(16)
# tree.insert(14)

tree.delete(67)
tree.delete(8)

tree.depth(23)

# tree.insert(8)
tree.pretty_print

# tree.insert(9)

tree.pretty_print
p tree.balanced?
