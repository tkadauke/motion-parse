module MotionParse
  class Base
    attr_accessor :parse_object
    
    class_attribute :attributes
    self.attributes = []
    
    def self.attribute(*fields)
      fields.each do |field|
        define_method field do
          @parse_object.objectForKey(field)
        end
        define_method "#{field}=" do |value|
          @parse_object.setObject(value, forKey:field)
        end
      end
      self.attributes += fields
    end
    
    def initialize(arg = nil)
      if arg.is_a?(PFObject)
        @parse_object = arg
      elsif arg.is_a?(MotionParse::Base)
        @parse_object = PFObject.objectWithClassName(self.class.name)
        arg.attributes.each do |key, value|
          @parse_object.setObject(value, forKey:key) if attributes.include?(key)
        end
      else
        @parse_object = PFObject.objectWithClassName(self.class.name)
        if arg.is_a?(Hash)
          arg.each do |key, value|
            @parse_object.setObject(value, forKey:key) if attributes.include?(key)
          end
        end
      end
    end
    
    def attributes
      self.class.attributes.inject({}) { |hash, var| hash[var] = send(var); hash }
    end
    
    def self.find(hash, &block)
      q = query
      hash.each do |key, value|
        q.whereKey(key, equalTo:value)
      end
      
      get(q, &block)
    end
    
    def self.all(&block)
      find({}, &block)
    end
    
    def self.has_many(association)
      define_method association do |&block|
        klass = association.to_s.classify.constantize
        klass.find(self.class.name.foreign_key => parse_object, &block)
      end
    end
    
    def self.belongs_to(association)
      define_method association do
        self.send(association.to_s.foreign_key)
      end
      define_method "#{association}=" do |val|
        self.send("#{association.to_s.foreign_key}=", val)
      end
    end
    
    def self.query
      PFQuery.alloc.initWithClassName(self.name)
    end
    
    def self.get(query, &block)
      if block
        query.find_in_background do |objects, error|
          objects = objects.map { |obj| new(obj) } if objects
          block.call(objects, error)
        end
      else
        query.findObjects.map { |obj| new(obj) }
      end
    end
  end
end
