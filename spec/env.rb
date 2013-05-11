PFObject = Class.new unless Object.const_defined?(:PFObject)
PFQuery = Class.new unless Object.const_defined?(:PFQuery)
PFUser = Class.new unless Object.const_defined?(:PFUser)

class Author < MotionParse::Base
  attribute :first_name, :last_name, :age
  attr_alias :name, :last_name
  
  has_many :posts
end

class Post < MotionParse::Base
  attribute :title, :text, :author_id
  
  belongs_to :author
end
