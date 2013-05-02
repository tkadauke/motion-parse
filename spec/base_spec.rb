describe "Base" do
  describe "attributes" do
    it "should store attributes in class array" do
      Author.attributes.should == [:first_name, :last_name, :age]
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
    
    it "should accept hash with unknown key and generate parse object" do
      Author.new(:foo => 'Bar').parse_object.should.not.be.nil
    end
    
    it "should accept no arg and generage parse object" do
      Author.new.parse_object.should.not.be.nil
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
end
