class Node
  attr_accessor :right, :left, :data

  include Comparable

  def <=>(other)
    @data <=> other.data
  end

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end
