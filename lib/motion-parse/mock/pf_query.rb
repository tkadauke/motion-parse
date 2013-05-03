module MotionParse
  module Mock
    class PFQuery
      attr_reader :constraints
      cattr_accessor :last_object
      cattr_accessor :result_objects
      
      attr_accessor :limit, :skip
  
      def initWithClassName(name)
        @constraints = {}
        MotionParse::Mock::PFQuery.last_object = self
        self
      end
  
      def whereKey(key, equalTo:value)
        @constraints[key] = value
      end
  
      def find_in_background(&block)
        block.call(result_objects || [], nil)
      end
      
      def first_in_background(&block)
        block.call(result_objects.first, nil)
      end
      
      def count_in_background(&block)
        block.call(result_objects.size, nil)
      end
  
      def findObjects
        result_objects || []
      end
      
      def getFirstObject
        result_objects.first
      end
      
      def countObjects
        result_objects.size
      end
    end
  end
end
