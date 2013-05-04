module MotionParse
  class Query
    attr_reader :owner
    
    def initialize(owner)
      @owner = owner
      @pf_query = PFQuery.alloc.initWithClassName(@owner.name)
    end
    
    def where(*args)
      if args.size == 1 && args.first.is_a?(Hash)
        args.first.each do |key, value|
          @pf_query.whereKey(key, equalTo:value)
        end
      elsif args.size == 2 && args.first.is_a?(Symbol) && args.last.is_a?(Hash)
        raise NotImplementedError
      else
        raise ArgumentError
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
