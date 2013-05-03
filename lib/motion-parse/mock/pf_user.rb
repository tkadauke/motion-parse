module MotionParse
  module Mock
    class PFUser < PFObject
      cattr_accessor :currentUser
      def self.user
        new
      end
    end
  end
end
