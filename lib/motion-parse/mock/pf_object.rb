module MotionParse
  module Mock
    class PFObject
      attr_reader :fields
  
      def self.objectWithClassName(name)
        new
      end
  
      def initialize
        @fields = {}
      end
  
      def objectForKey(field)
        @fields[field]
      end
  
      def setObject(value, forKey:key)
        @fields[key] = value
      end
    end
  end
end
