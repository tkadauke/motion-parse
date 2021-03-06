describe "Base" do
  extend MotionParse::SpecHelper
  
  describe "attributes" do
    it "should store attributes in class array" do
      Author.attributes.should == MotionParse::Base.attributes + [:first_name, :last_name, :age]
    end
    
    it "should generate reader methods" do
      Author.new.should.respond_to :first_name
      Author.new.should.respond_to :last_name
      Author.new.should.respond_to :age
    end
    
    it "should generate writer methods" do
      Author.new.should.respond_to :first_name=
      Author.new.should.respond_to :last_name=
      Author.new.should.respond_to :age=
    end
    
    it "should return nil for unset attribute" do
      Author.new.first_name.should.be.nil
    end
    
    it "should set and get attribute" do
      author = Author.new
      author.first_name = "John"
      author.first_name.should == "John"
    end
    
    it "should return a hash with all attributes set to nil when no attributes are set" do
      Author.new.attributes.should == { :first_name => nil, :last_name => nil, :age => nil }
    end
    
    it "should return a hash of all attributes on instance with all values set" do
      author = Author.new(:first_name => 'John', :last_name => 'Doe', :age => 10)
      author.attributes.should == { :first_name => 'John', :last_name => 'Doe', :age => 10 }
    end
  end
  
  describe "attr_alias" do
    it "should have attribute aliases for timestamps by default" do
      MotionParse::Base.attribute_aliases.should == { :created_at => :createdAt, :updated_at => :updatedAt }
    end
    
    it "should inherit aliases" do
      Author.attribute_aliases.should == { :created_at => :createdAt, :updated_at => :updatedAt, :name => :last_name }
    end
    
    it "should define alias for reader" do
      author = Author.new(:last_name => 'John')
      author.name.should == 'John'
    end
    
    it "should define alias for writer" do
      author = Author.new(:last_name => 'John')
      author.name = 'Paul'
      author.last_name.should == 'Paul'
    end
  end
  
  describe "initialize" do
    it "should accept parse object" do
      obj = PFObject.new
      Author.new(obj).parse_object.should == obj
    end
    
    it "should accept hash and generate parse object" do
      Author.new(:first_name => 'John').parse_object.should.not.be.nil
    end
    
    it "should accept hash and store values" do
      Author.new(:first_name => 'John').first_name.should == 'John'
    end
    
    it "should resolve aliases" do
      Author.new(:name => 'John').last_name.should == 'John'
    end
    
    it "should accept hash with unknown key and generate parse object" do
      Author.new(:foo => 'Bar').parse_object.should.not.be.nil
    end
    
    it "should accept no arg and generate parse object" do
      Author.new.parse_object.should.not.be.nil
    end
    
    it "should accept MotionParse::Base object and generate parse object" do
      Author.new(Author.new).parse_object.should.not.be.nil
    end
    
    it "should accept MotionParse::Base object and store values" do
      Author.new(Author.new(:first_name => 'John')).first_name.should == 'John'
    end
  end
  
  describe "find" do
    it "should find with constraints" do
      Author.find(:foo => 'bar', :baz => 'boom')
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
    end
    
    it "should call block with results when given" do
      PFQuery.result_objects = [1, 2, 3]
      @result = nil
      Author.find(:foo => 'bar') do |objects|
        @result = objects
      end
      @result.size.should == 3
    end
    
    it "should return models immediately when no block given" do
      PFQuery.result_objects = [1, 2, 3]
      Author.find(:foo => 'bar').size.should == 3
    end
  end
  
  describe "first" do
    it "should find first with constraints" do
      Author.first(:foo => 'bar', :baz => 'boom')
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
    end
    
    it "should call block with result when given" do
      PFQuery.result_objects = [Author.new(:first_name => 'John')]
      @result = nil
      Author.first(:foo => 'bar') do |object|
        @result = object
      end
      @result.first_name.should == 'John'
    end
    
    it "should return result immediately when no block given" do
      PFQuery.result_objects = [Author.new(:first_name => 'John')]
      Author.first(:foo => 'bar').first_name.should == 'John'
    end
  end
  
  describe "count" do
    it "should count with constraints" do
      Author.count(:foo => 'bar', :baz => 'boom')
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
    end
    
    it "should call block with count when given" do
      PFQuery.result_objects = [Author.new(:first_name => 'John')]
      @result = nil
      Author.count(:foo => 'bar') do |num|
        @result = num
      end
      @result.should == 1
    end
    
    it "should return count immediately when no block given" do
      PFQuery.result_objects = [Author.new(:first_name => 'John')]
      Author.count(:foo => 'bar').should == 1
    end
  end
  
  describe "has_many" do
    it "should constrain with association" do
      author = Author.new
      author.posts
      PFQuery.last_object.constraints.should == { 'author_id' => author.parse_object }
    end
    
    it "should call block with results when given" do
      PFQuery.result_objects = [1, 2, 3]
      @result = nil
      Author.new.posts do |objects|
        @result = objects
      end
      @result.size.should == 3
    end
    
    it "should return models immediately when no block given" do
      PFQuery.result_objects = [1, 2, 3]
      Author.new.posts.size.should == 3
    end
  end
  
  describe "belongs_to" do
    it "should define getter method" do
      obj = Object.new
      Post.new(:author_id => obj).author.should == obj
    end
    
    it "should define setter method" do
      obj = Object.new
      post = Post.new
      post.author = obj
      post.author_id.should == obj
    end
  end
  
  describe "where" do
    it "should delegate to query object" do
      Author.where(:foo => 'bar', :baz => 'boom').find
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
    end
    
    it "should allow to daisy chain" do
      Author.where(:foo => 'bar').where(:baz => 'boom').find
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
    end
  end
  
  describe "limit" do
    it "should delegate to query object" do
      Author.limit(10).find
      PFQuery.last_object.limit.should == 10
    end
    
    it "should allow daisy chain" do
      Author.limit(10).where(:foo => 'bar').find
      PFQuery.last_object.limit.should == 10
    end
  end
  
  describe "offset/skip" do
    it "should delegate offset to query object" do
      Author.offset(10).find
      PFQuery.last_object.skip.should == 10
    end

    it "should delegate skip to query object" do
      Author.skip(10).find
      PFQuery.last_object.skip.should == 10
    end
    
    it "should allow daisy chain" do
      Author.offset(10).where(:foo => 'bar').find
      PFQuery.last_object.skip.should == 10
    end
  end
  
  describe "save" do
    it "should save object now" do
      author = Author.new(:first_name => 'John')
      author.save(:now)
      author.parse_object.save_at.should == :now
    end

    it "should save object in background" do
      author = Author.new(:first_name => 'John')
      author.save(:background)
      author.parse_object.save_at.should == :background
    end
    
    it "should save object eventually" do
      author = Author.new(:first_name => 'John')
      author.save(:eventually)
      author.parse_object.save_at.should == :eventually
    end
  end
  
  describe "delete" do
    it "should delete object now" do
      author = Author.new
      author.delete(:now)
      author.parse_object.delete_at.should == :now
    end

    it "should delete object in background" do
      author = Author.new
      author.delete(:background)
      author.parse_object.delete_at.should == :background
    end
    
    it "should delete object eventually" do
      author = Author.new
      author.delete(:eventually)
      author.parse_object.delete_at.should == :eventually
    end
  end
  
  describe "create" do
    it "should create an object now" do
      author = Author.create(:first_name => 'John')
      author.parse_object.save_at.should == :now
    end
    
    it "should set attributes on create" do
      author = Author.create(:first_name => 'John')
      author.first_name.should == 'John'
    end
  end
  
  describe "refresh" do
    it "should refresh in background" do
      author = Author.new
      old_obj = author.parse_object
      author.refresh do |obj|
        @refreshed = true
        old_obj.should.not == author.parse_object
      end
    end
    
    it "should refresh now" do
      author = Author.new
      author.refresh
      author.parse_object.refreshed.should.be.true
    end
  end
  
  describe "callbacks" do
    it "should run callbacks when saving" do
      author = Post.new(:title => 'Hello World')
      author.save(:now)
      author.callback_history.should == ["before_save", "after_save"]
    end
    
    it "should run callbacks when deleting" do
      author = Post.new(:title => 'Hello World')
      author.delete(:now)
      author.callback_history.should == ["before_delete", "after_delete"]
    end
  end
end
