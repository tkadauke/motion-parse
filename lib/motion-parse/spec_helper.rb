module MotionParse
  module SpecHelper
    module_function
    
    def extended(receiver)
      receiver.before do
        mock!
      end
      
      receiver.after do
        unmock!
      end
    end
    
    CLASSES = [:PFObject, :PFQuery, :PFUser]
    
    def mock!
      raise "called MotionParse::SpecHelper#mock! twice in a row without calling #unmock!" if @mocked
      
      CLASSES.each do |klass|
        mock_class!(klass)
      end
      @mocked = true
    end
    
    def unmock!
      raise "called MotionParse::SpecHelper#unmock! twice in a row without calling #mock!" unless @mocked
      
      CLASSES.each do |klass|
        unmock_class!(klass)
      end
      @mocked = false
    end
    
    def mock_class!(klass)
      @original_classes ||= {}
      @original_classes[klass] = klass.to_s.constantize
      
      Object.send(:remove_const, klass)
      Object.const_set(klass, "MotionParse::Mock::#{klass}".constantize)
    end
    
    def unmock_class!(klass)
      Object.send(:remove_const, klass)
      Object.const_set(klass, @original_classes.delete(klass))
    end
  end
end
