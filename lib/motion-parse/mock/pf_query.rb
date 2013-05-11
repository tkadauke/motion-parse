module MotionParse
  module Mock
    class PFQuery
      attr_reader :constraints, :order
      cattr_accessor :last_object
      cattr_accessor :result_objects
      
      attr_accessor :limit, :skip
  
      def initWithClassName(name)
        @constraints = {}
        @order = {}
        MotionParse::Mock::PFQuery.last_object = self
        self
      end
  
      def whereKey(key, equalTo:value)
        @constraints[key] = value
      end

      def whereKey(key, notEqualTo:value)
        @constraints[key] = value
      end

      def whereKey(key, lessThan:value)
        @constraints[key] = value
      end

      def whereKey(key, greaterThan:value)
        @constraints[key] = value
      end

      def whereKey(key, lessThanOrEqualTo:value)
        @constraints[key] = value
      end

      def whereKey(key, greaterThanOrEqualTo:value)
        @constraints[key] = value
      end

      def whereKey(key, containedIn:value)
        @constraints[key] = value
      end

      def whereKey(key, notContainedIn:value)
        @constraints[key] = value
      end

      def whereKey(key, containsAllObjectsInArray:value)
        @constraints[key] = value
      end

      def whereKey(key, matchesRegex:value)
        @constraints[key] = value
      end

      def whereKey(key, containsString:value)
        @constraints[key] = value
      end

      def whereKey(key, hasPrefix:value)
        @constraints[key] = value
      end

      def whereKey(key, hasSuffix:value)
        @constraints[key] = value
      end
      
      def orderByAscending(field)
        @order[field] = :asc
      end

      def orderByDescending(field)
        @order[field] = :desc
      end

      def addAscendingOrder(field)
        @order[field] = :asc
      end

      def addDescendingOrder(field)
        @order[field] = :desc
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
