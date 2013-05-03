class PFQuery
  def find_in_background(&block)
    findObjectsInBackgroundWithBlock(block)
  end
  
  def first_in_background(&block)
    getFirstObjectInBackgroundWithBlock(block)
  end
  
  def count_in_background(&block)
    countObjectsInBackgroundWithBlock(block)
  end
end
