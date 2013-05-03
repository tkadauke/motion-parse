describe "Query" do
  extend MotionParse::SpecHelper
  
  describe "where" do
    it "should add constraints if called with hash" do
      MotionParse::Query.new(Author).where(:foo => 'bar', :baz => 'boom').find
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
    end
    
    it "should return self" do
      query = MotionParse::Query.new(Author)
      query.where(:foo => 'bar').should == query
    end
    
    it "should allow to daisy chain" do
      MotionParse::Query.new(Author).where(:foo => 'bar').where(:baz => 'boom').find
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
    end
    
    it "should raise if called with no arguments" do
      lambda { MotionParse::Query.new(Author).where }.should.raise ArgumentError
    end
    
    it "should raise if called with one argument that isn't a hash" do
      lambda { MotionParse::Query.new(Author).where('hello') }.should.raise ArgumentError
    end
    
    it "should raise if called with two arguments that aren't symbol and hash" do
      lambda { MotionParse::Query.new(Author).where('hello', 'world') }.should.raise ArgumentError
      lambda { MotionParse::Query.new(Author).where(3, { :foo => 10 }) }.should.raise ArgumentError
    end
    
    it "should raise if called with more than two arguments" do
      lambda { MotionParse::Query.new(Author).where(:hello, { :world => 'foo' }, 'bar') }.should.raise ArgumentError
    end
  end

  describe "find" do
    it "should find with constraints" do
      MotionParse::Query.new(Author).where(:foo => 'bar', :baz => 'boom').find
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
    end
    
    it "should call block with results when given" do
      PFQuery.result_objects = [1, 2, 3]
      @result = nil
      MotionParse::Query.new(Author).where(:foo => 'bar').find do |objects|
        @result = objects
      end
      @result.size.should == 3
    end
    
    it "should return models immediately when no block given" do
      PFQuery.result_objects = [1, 2, 3]
      MotionParse::Query.new(Author).where(:foo => 'bar').find.size.should == 3
    end
  end

  describe "first" do
    it "should find first with constraints" do
      MotionParse::Query.new(Author).where(:foo => 'bar', :baz => 'boom').first
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
    end
    
    it "should call block with results when given" do
      PFQuery.result_objects = [Author.new(:first_name => 'John')]
      @result = nil
      MotionParse::Query.new(Author).where(:foo => 'bar').first do |object|
        @result = object
      end
      @result.first_name.should == 'John'
    end
    
    it "should return models immediately when no block given" do
      PFQuery.result_objects = [Author.new(:first_name => 'John')]
      MotionParse::Query.new(Author).where(:foo => 'bar').first.first_name.should == 'John'
    end
  end

  describe "count" do
    it "should count with constraints" do
      MotionParse::Query.new(Author).where(:foo => 'bar', :baz => 'boom').count
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
    end
    
    it "should call block with count when given" do
      PFQuery.result_objects = [Author.new(:first_name => 'John')]
      @result = nil
      MotionParse::Query.new(Author).where(:foo => 'bar').count do |num|
        @result = num
      end
      @result.should == 1
    end
    
    it "should return count immediately when no block given" do
      PFQuery.result_objects = [Author.new(:first_name => 'John')]
      MotionParse::Query.new(Author).where(:foo => 'bar').count.should == 1
    end
  end
  
  describe "limit" do
    it "should set limit" do
      MotionParse::Query.new(Author).limit(10).find
      PFQuery.last_object.limit.should == 10
    end
    
    it "should return self" do
      query = MotionParse::Query.new(Author)
      query.limit(10).should == query
    end
    
    it "should let last call win when daisy chaining limit" do
      MotionParse::Query.new(Author).limit(5).limit(10).find
      PFQuery.last_object.limit.should == 10
    end
  end
  
  describe "offset/skip" do
    it "should set skip" do
      MotionParse::Query.new(Author).offset(10).find
      PFQuery.last_object.skip.should == 10
    end
    
    it "should return self" do
      query = MotionParse::Query.new(Author)
      query.skip(10).should == query
    end
    
    it "should let last call win when daisy chaining skip" do
      MotionParse::Query.new(Author).offset(5).offset(10).find
      PFQuery.last_object.skip.should == 10
    end
  end
end
