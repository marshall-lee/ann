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
    let(:otto) { klass.annotations }
    context 'method without annotations' do
      before do
        klass.class_eval do
          def frank
          end
        end
      end

      it 'should store annotation instance in the list' do
        expect(otto[:frank]).to eq []
      end
    end

    context 'with one annotation for method' do
      let(:ann_klass) { Struct.new(:klass, :method, :a, :b) }

      before do
        ann_klass = self.ann_klass
        klass.class_eval do
          ann ann_klass, 123, 456
          def frank
          end
        end
      end

      it 'should store annotation instance in the list' do
        expect(otto[:frank]).to contain_exactly(ann_klass.new(klass, :frank, 123, 456))
      end

      it 'passes class and method name along with an arguments to annotations class constructor' do
        ann_klass = self.ann_klass
        expect(ann_klass).to receive(:new).with(klass, :frank, 123, 456)
        klass.class_eval do
          ann ann_klass, 123, 456
          def frank
          end
        end
      end

      context 'in the inherited class' do
        let(:subclass) { Class.new(klass) }
        let(:anne) { subclass.annotations }

        it 'should be able to get inherited annotations' do
          expect(anne[:frank]).to contain_exactly(ann_klass.new(klass, :frank, 123, 456))
        end

        context 'when overriding a method' do
          let(:ann_klass1) { Struct.new(:klass, :method, :x, :y) }
          let(:subclass1) do
            ann_klass = self.ann_klass1
            Class.new(klass) do
              ann ann_klass, :foo, :bar
              def frank
                super
              end
            end
          end
          let(:anne) { subclass1.annotations }

          let(:ann_klass2) { Struct.new(:klass, :method, :s, :t) }
          let(:subclass2) do
            ann_klass = self.ann_klass2
            Class.new(klass) do
              ann ann_klass, 'xx', 'yy'
              def frank
                super
              end
            end
          end
          let(:margot) { subclass2.annotations }

          it 'adds new annotations on top of inherited' do
            expect(anne[:frank]).to contain_exactly(
              ann_klass.new(klass, :frank, 123, 456),
              ann_klass1.new(subclass1, :frank, :foo, :bar)
            )
            expect(margot[:frank]).to contain_exactly(
              ann_klass.new(klass, :frank, 123, 456),
              ann_klass2.new(subclass2, :frank, 'xx', 'yy')
            )
          end
        end
      end
    end
  end

  describe '.annotations_for' do
    let(:ann_klass) { Struct.new(:klass, :method, :a, :b) }

    before do
      ann_klass = self.ann_klass
      klass.class_eval do
        ann ann_klass, 123, 456
        def meth
        end
      end
    end

    it 'returns method annotations' do
      expect(klass.annotations_for(:meth)).to eq [ann_klass.new(klass, :meth, 123, 456)]
    end
  end
end
