require_relative 'ruby-binary-search/tree'

data = (Array.new(15) { rand(1..100) })

tree = Tree.new(data)
p "Balanced: #{tree.balanced?}"

level_order_elements = []
tree.level_order { |el| level_order_elements.push(el) }
p "Level order: #{level_order_elements}"

pre_order_elements = []
tree.preorder { |el| pre_order_elements.push(el) }
p "Pre order: #{pre_order_elements}"

post_order_elements = []
tree.postorder { |el| post_order_elements.push(el) }
p "Post order: #{post_order_elements}"

in_order_elements = []
tree.inorder { |el| in_order_elements.push(el) }
p "In order: #{in_order_elements}"

tree.insert(101)
tree.insert(102)
p "Balanced: #{tree.balanced?}"
tree.rebalance
p "Balanced: #{tree.balanced?}"

level_order_elements = []
tree.level_order { |el| level_order_elements.push(el) }
p "Level order: #{level_order_elements}"

pre_order_elements = []
tree.preorder { |el| pre_order_elements.push(el) }
p "Pre order: #{pre_order_elements}"

post_order_elements = []
tree.postorder { |el| post_order_elements.push(el) }
p "Post order: #{post_order_elements}"

in_order_elements = []
tree.inorder { |el| in_order_elements.push(el) }
p "In order: #{in_order_elements}"
