describe "User" do
  extend MotionParse::SpecHelper
  
  describe "attributes" do
    [:username, :password, :email].each do |attr|
      it "should have #{attr} attribute" do
        MotionParse::User.new.should.respond_to attr
        MotionParse::User.new.should.respond_to "#{attr}="
        MotionParse::User.attributes.should.include attr
      end
    end
  end
  
  describe "current" do
    it "should return user model with current user if set" do
      PFUser.currentUser = Object.new
      
      MotionParse::User.current.should.is_a MotionParse::User
      MotionParse::User.current.parse_object.should == PFUser.currentUser
    end
    
    it "should return nil if no current user is set" do
      PFUser.currentUser = nil
      
      MotionParse::User.current.should.be.nil
    end
  end
end
