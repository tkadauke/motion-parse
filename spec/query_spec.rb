describe "Query" do
  extend MotionParse::SpecHelper
  
  describe "where" do
    it "should be a no-op when called without an argument" do
      query = MotionParse::Query.new(Author)
      query.where.should == query
    end
    
    it "should be a synonym to equals when called with a hash" do
      MotionParse::Query.new(Author).where(:foo => 'bar', :baz => 'boom').find
      PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
    end
  end
  
  [
    :equal, :not_equal, :less_than, :greater_than, :less_than_or_equal, :greater_than_or_equal,
    :eq, :ne, :lt, :gt, :lte, :gte,
    :contained_in, :not_contained_in, :contains, :matches, :contains_string, :has_prefix, :has_suffix
  ].each do |method|
    describe method do
      it "should add constraints if called with hash" do
        MotionParse::Query.new(Author).send(method, :foo => 'bar', :baz => 'boom').find
        PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
      end
    
      it "should return self" do
        query = MotionParse::Query.new(Author)
        query.send(method, :foo => 'bar').should == query
      end
    
      it "should allow to daisy chain" do
        MotionParse::Query.new(Author).send(method, :foo => 'bar').send(method, :baz => 'boom').find
        PFQuery.last_object.constraints.should == { :foo => 'bar', :baz => 'boom' }
      end
      
      it "should resolve alias" do
        MotionParse::Query.new(Author).send(method, :created_at => 'today', :updated_at => 'today').find
        PFQuery.last_object.constraints.should == { :createdAt => 'today', :updatedAt => 'today' }
      end
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
    
    it "should return nil immediately when no block given and nothing is found" do
      PFQuery.result_objects = []
      MotionParse::Query.new(Author).where(:foo => 'bar').first.should.be.nil
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
  
  describe "order" do
    it "should add orders if called with hash" do
      MotionParse::Query.new(Author).order(:name => :asc, :age => :desc).find
      PFQuery.last_object.order.should == { :name => :asc, :age => :desc }
    end
    
    it "should return self" do
      query = MotionParse::Query.new(Author)
      query.order(:name => :asc).should == query
    end
    
    it "should combine order when daisy chaining" do
      MotionParse::Query.new(Author).order(:name => :asc).order(:age => :desc).find
      PFQuery.last_object.order.should == { :name => :asc, :age => :desc }
    end
  end
end
