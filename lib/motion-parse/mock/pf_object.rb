module MotionParse
  module Mock
    class PFObject
      attr_reader :fields
      attr_reader :save_at, :delete_at
  
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
      
      def save
        @save_at = :now
      end
      
      def saveInBackground
        @save_at = :background
      end
      
      def saveEventually
        @save_at = :eventually
      end
      
      def delete
        @delete_at = :now
      end
      
      def deleteInBackground
        @delete_at = :background
      end
      
      def deleteEventually
        @delete_at = :eventually
      end
    end
  end
end
