require 'ann/version'
require 'thread'

module Ann
  Descriptor = Struct.new(:klass, :args)

  def ann(*args)
    klass, *args = args
    Thread.current[:ann_descriptors] ||= []
    Thread.current[:ann_descriptors] << Descriptor.new(klass, args)
  end

  def annotations
    @annotations ||= Hash.new { |hash, key| hash[key] = [] }
  end

  def annotations_for(name)
    annotations[name]
  end

  def method_added(name)
    method_anns = (Thread.current[:ann_descriptors] || []).map do |desc|
      desc.klass.new(self, name, *desc.args)
    end
    annotations[name].concat(method_anns)

    Thread.current[:ann_descriptors] = nil
  end

  def inherited(subclass)
    parent = self
    subclass.class_eval do
      @annotations = Hash[parent.annotations.map { |name, anns| [name, anns.dup] }]
    end
  end
end
