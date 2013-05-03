describe "SpecHelper" do
  describe "mock!" do
    after do
      MotionParse::SpecHelper.unmock!
    end
    
    it "should move the original classes out of the way" do
      PFQuery.should.not.respond_to :last_object
      MotionParse::SpecHelper.mock!
      PFQuery.should.respond_to :last_object
    end
    
    it "should raise if called twice in a row" do
      MotionParse::SpecHelper.mock!
      lambda { MotionParse::SpecHelper.mock! }.should.raise
    end
  end
  
  describe "unmock!" do
    before do
      MotionParse::SpecHelper.mock!
    end
    
    it "should restore the original classes" do
      PFQuery.should.respond_to :last_object
      MotionParse::SpecHelper.unmock!
      PFQuery.should.not.respond_to :last_object
    end
    
    it "should raise if called twice in a row" do
      MotionParse::SpecHelper.unmock!
      lambda { MotionParse::SpecHelper.unmock! }.should.raise
    end
  end
end
