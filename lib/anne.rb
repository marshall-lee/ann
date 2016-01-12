require 'anne/version'
require 'thread'

module Anne
  Descriptor = Struct.new(:klass, :args)

  def anne(*args)
    klass, *args = args
    Thread.current[:anne_descriptors] ||= []
    Thread.current[:anne_descriptors] << Descriptor.new(klass, args)
  end
  alias ann anne

  def annotations
    @annotations ||= Hash.new { |hash, key| hash[key] = [] }
  end

  def annotations_for(name)
    annotations[name]
  end

  def method_added(name)
    method_anns = (Thread.current[:anne_descriptors] || []).map do |desc|
      desc.klass.new(self, name, *desc.args)
    end
    annotations[name].concat(method_anns)

    Thread.current[:anne_descriptors] = nil
  end

  def inherited(subclass)
    parent = self
    subclass.class_eval do
      @annotations = Hash[parent.annotations.map { |name, anns| [name, anns.dup] }]
    end
  end
end
