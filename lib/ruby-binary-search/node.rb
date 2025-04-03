class Node
  include Comparable

  def <=>(other)
    @data <=> other.data
  end

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = nil
    @right = nil
  end
end
