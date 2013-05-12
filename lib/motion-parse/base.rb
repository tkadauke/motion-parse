module MotionParse
  class Base
    include MotionSupport::Callbacks
    
    attr_accessor :parse_object
    
    class_attribute :attributes
    self.attributes = []
    class_attribute :attribute_aliases
    self.attribute_aliases = {}
    
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
    
    delegate :createdAt, :createdAt=, :updatedAt, :updatedAt=, :to => :parse_object
    
    def self.attr_alias(new_name, old_name)
      alias_method new_name, old_name
      alias_method "#{new_name}=", "#{old_name}="
      self.attribute_aliases = self.attribute_aliases.dup
      self.attribute_aliases[new_name] = old_name
    end
    
    attr_alias :created_at, :createdAt
    attr_alias :updated_at, :updatedAt
    
    def initialize(arg = nil)
      if arg.is_a?(PFObject)
        @parse_object = arg
      elsif arg.is_a?(MotionParse::Base)
        @parse_object = PFObject.objectWithClassName(self.class.name)
        arg.attributes.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      else
        @parse_object = PFObject.objectWithClassName(self.class.name)
        if arg.is_a?(Hash)
          arg.each do |key, value|
            send("#{key}=", value) if respond_to?("#{key}=")
          end
        end
      end
    end
    
    def attributes
      self.class.attributes.inject({}) { |hash, var| hash[var] = send(var); hash }
    end
    
    def self.find(hash = {}, &block)
      where(hash).find(&block)
    end
    
    def self.first(hash = {}, &block)
      where(hash).first(&block)
    end
    
    def self.last(hash = {}, &block)
      where(hash).order(:createdAt => :desc).first(&block)
    end
    
    def self.count(hash = {}, &block)
      where(hash).count(&block)
    end
    
    def self.all(&block)
      find({}, &block)
    end
    
    def self.has_many(association)
      define_method association do |&block|
        klass = association.to_s.classify.constantize
        klass.where(self.class.name.foreign_key => parse_object).find(&block)
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
      Query.new(self)
    end
    
    class << self
      delegate :where, :limit, :offset, :skip, :to => :query
    end
    
    def save(at = :now)
      run_callbacks :save do
        case at
        when :now
          @parse_object.save
        when :later, :background
          @parse_object.saveInBackground
        when :eventually
          @parse_object.saveEventually
        end
      end
    end
    
    def delete(at = :now)
      run_callbacks :delete do
        case at
        when :now
          @parse_object.delete
        when :later, :background
          @parse_object.deleteInBackground
        when :eventually
          @parse_object.deleteEventually
        end
      end
    end
    alias destroy delete
    
    def self.create(attributes = {}, at = :now)
      new(attributes).tap do |obj|
        obj.save(at)
      end
    end
    
    def refresh(&block)
      if block
        this = self
        @parse_object.refresh_in_background do |object, error|
          this.parse_object = object
          block.call(this, error)
        end
      else
        @parse_object.refresh
      end
    end
    
    define_callbacks :save, :delete

    def self.before_save(*filters, &blk)
      set_callback(:save, :before, *filters, &blk)
    end

    def self.after_save(*filters, &blk)
      set_callback(:save, :after, *filters, &blk)
    end
    
    def self.before_delete(*filters, &blk)
      set_callback(:delete, :before, *filters, &blk)
    end

    def self.after_delete(*filters, &blk)
      set_callback(:delete, :after, *filters, &blk)
    end
  end
end
