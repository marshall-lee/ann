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

  describe '.ann' do
    context 'method without annotations' do
      before do
        klass.class_eval do
          def frank
          end
        end
      end

      it 'should store annotation instance in the list' do
        expect(klass.anne[:frank]).to eq []
      end
    end

    context 'with one annotation for method' do
      let(:ann_klass) { Struct.new(:a, :b) }

      before do
        ann_klass = self.ann_klass
        klass.class_eval do
          ann ann_klass, 123, 456
          def frank
          end
        end
      end

      it 'should store annotation instance in the list' do
        expect(klass.anne[:frank]).to contain_exactly(ann_klass.new(123, 456))
      end
    end
  end
end
