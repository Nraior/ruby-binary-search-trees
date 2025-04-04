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

  def left_contains_value?(value)
    left&.data == value
  end

  def right_contains_value?(value)
    right&.data == value
  end

  def left_child_exist?
    !@left.nil?
  end

  def right_child_exist?
    !@right.nil?
  end
end
