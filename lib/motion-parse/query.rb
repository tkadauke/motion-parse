module MotionParse
  class Query
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
        @pf_query.find_in_background do |objects, error|
          objects = objects.map { |obj| @owner.new(obj) } if objects
          block.call(objects, error)
        end
      else
        @pf_query.findObjects.map { |obj| @owner.new(obj) }
      end
    end
  end
end
