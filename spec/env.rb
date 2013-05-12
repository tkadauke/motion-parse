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
  
  before_save :before_save_post
  after_save :after_save_post
  before_delete :before_delete_post
  after_delete :after_delete_post
  
  def before_save_post
    callback_history << "before_save"
  end
  
  def after_save_post
    callback_history << "after_save"
  end
  
  def before_delete_post
    callback_history << "before_delete"
  end
  
  def after_delete_post
    callback_history << "after_delete"
  end
  
  def callback_history
    @callback_history ||= []
  end
end
