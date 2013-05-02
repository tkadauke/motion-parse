class PFObject
  attr_reader :fields
  
  def self.objectWithClassName(name)
    new
  end
  
  def initialize
    @fields = {}
  end
  
  def objectForKey(field)
    @fields[field]
  end
  
  def setObject(value, forKey:key)
    @fields[key] = value
  end
end

class PFQuery
  attr_reader :constraints
  cattr_accessor :last_object
  cattr_accessor :result_objects
  
  def initWithClassName(name)
    @constraints = {}
    PFQuery.last_object = self
    self
  end
  
  def whereKey(key, equalTo:value)
    @constraints[key] = value
  end
  
  def findObjectsInBackgroundWithBlock(block)
    block.call(result_objects || [], nil)
  end
  
  def findObjects
    result_objects || []
  end
end

class PFUser
  cattr_accessor :currentUser
  def self.user
    new
  end
end

class Author < MotionParse::Base
  attribute :first_name, :last_name, :age
  
  has_many :posts
end

class Post < MotionParse::Base
  attribute :title, :text, :author_id
  
  belongs_to :author
end
