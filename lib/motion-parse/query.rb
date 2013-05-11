module MotionParse
  class Query
    attr_reader :owner
    
    def initialize(owner)
      @owner = owner
      @pf_query = PFQuery.alloc.initWithClassName(@owner.name)
    end
    
    def where(options = nil)
      options ? equal(options) : self
    end
    
    def equal(options)
      options.each do |key, value|
        @pf_query.whereKey key, equalTo:value
      end
      self
    end
    alias eq equal
    
    def not_equal(options)
      options.each do |key, value|
        @pf_query.whereKey key, notEqualTo:value
      end
      self
    end
    alias ne not_equal
    
    def less_than(options)
      options.each do |key, value|
        @pf_query.whereKey key, lessThan:value
      end
      self
    end
    alias lt less_than
    
    def greater_than(options)
      options.each do |key, value|
        @pf_query.whereKey key, greaterThan:value
      end
      self
    end
    alias gt greater_than
    
    def less_than_or_equal(options)
      options.each do |key, value|
        @pf_query.whereKey key, lessThanOrEqualTo:value
      end
      self
    end
    alias lte less_than_or_equal
    
    def greater_than_or_equal(options)
      options.each do |key, value|
        @pf_query.whereKey key, greaterThanOrEqualTo:value
      end
      self
    end
    alias gte greater_than_or_equal
    
    def contained_in(options)
      options.each do |key, value|
        @pf_query.whereKey key, containedIn:value
      end
      self
    end
    
    def not_contained_in(options)
      options.each do |key, value|
        @pf_query.whereKey key, notContainedIn:value
      end
      self
    end
    
    def contains(options)
      options.each do |key, value|
        @pf_query.whereKey key, containsAllObjectsInArray:value
      end
      self
    end
    
    def matches(options, modifiers = nil)
      options.each do |key, value|
        if modifiers
          @pf_query.whereKey key, matchesRegex:value, modifiers:modifiers
        else
          @pf_query.whereKey key, matchesRegex:value
        end
      end
      self
    end
    
    def contains_string(options)
      options.each do |key, value|
        @pf_query.whereKey key, containsString:value
      end
      self
    end
    
    def has_prefix(options)
      options.each do |key, value|
        @pf_query.whereKey key, hasPrefix:value
      end
      self
    end
    
    def has_suffix(options)
      options.each do |key, value|
        @pf_query.whereKey key, hasSuffix:value
      end
      self
    end
    
    def find(&block)
      if block
        query = self
        @pf_query.find_in_background do |objects, error|
          objects = objects.map { |obj| query.owner.new(obj) } if objects
          block.call(objects, error)
        end
      else
        @pf_query.findObjects.map { |obj| @owner.new(obj) }
      end
    end
    
    def first(&block)
      if block
        query = self
        @pf_query.first_in_background do |object, error|
          block.call(query.owner.new(object), error)
        end
      else
        @owner.new(@pf_query.getFirstObject)
      end
    end
    
    def count(&block)
      if block
        @pf_query.count_in_background do |result, error|
          block.call(result, error)
        end
      else
        @pf_query.countObjects
      end
    end
    
    def limit(num)
      @pf_query.limit = num
      self
    end
    
    def offset(num)
      @pf_query.skip = num
      self
    end
    alias skip offset
  end
end
