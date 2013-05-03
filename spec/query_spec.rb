describe "Query" do
  extend MotionParse::SpecHelper
  
  describe "where" do
    it "should add constraints if called with hash" do
      MotionParse::Query.new(Author).where(:foo => 'bar', :baz => 'boom').find
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
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
end
