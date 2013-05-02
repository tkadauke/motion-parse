module MotionParse
  class User < Base
    attribute :username, :password, :email
  
    def initialize
      super(PFUser.user)
    end
  
    def self.current
      if PFUser.currentUser
        new.tap do |u|
          u.parse_object = PFUser.currentUser
        end
      else
        return nil
      end
    end
  end
end
