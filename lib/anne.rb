require 'anne/version'
require 'thread'

module Anne
  Descriptor = Struct.new(:klass, :args)

  def anne(*args)
    if args.empty?
      @anne ||= {}
    else
      klass, *args = args
      Thread.current[:anne_descriptors] ||= []
      Thread.current[:anne_descriptors] << Descriptor.new(klass, args)
    end
  end
  alias ann anne

  def method_added(name)
    method_anns = (Thread.current[:anne_descriptors] || []).map do |desc|
      desc.klass.new(*desc.args)
    end
    anne[name] ||= []
    anne[name].concat(method_anns)

    Thread.current[:anne_descriptors] = nil
  end

  def inherited(subclass)
    parent = self
    subclass.class_eval do
      @anne = Hash[parent.anne.map { |name, anns| [name, anns.dup] }]
    end
  end
end
