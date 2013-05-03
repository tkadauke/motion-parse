class PFQuery
  def find_in_background(&block)
    findObjectsInBackgroundWithBlock(block)
  end
end
