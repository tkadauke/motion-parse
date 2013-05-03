module MotionParse
  module Mock
    class PFQuery
      attr_reader :constraints
      cattr_accessor :last_object
      cattr_accessor :result_objects
  
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
  
      def findObjects
        result_objects || []
      end
    end
  end
end
