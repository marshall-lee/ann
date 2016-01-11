require 'spec_helper'

describe Anne do
  it 'has a version number' do
    expect(Anne::VERSION).not_to be nil
  end

  let(:klass) do
    Class.new do
      extend Anne
    end
  end

  describe 'class with Anne mixin' do
    it 'should be a kind of Anne' do
      expect(klass).to be_kind_of(Anne)
    end

    it 'should respond to method anne' do
      expect(klass).to respond_to(:anne)
    end

    it 'should respond to method ann' do
      expect(klass).to respond_to(:ann)
    end
  end
end
