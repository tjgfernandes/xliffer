require 'spec_helper'
require 'nokogiri'

module XLIFFer
  describe XLIFF::String do
    let(:trans_unit) do
      <<-EOF
      <trans-unit id="my id">
        <source>Hello World</source>
        <target>Bonjour le monde</target>
      </trans-unit>
      EOF
    end

    let(:xml) do
      Oga.parse_xml(trans_unit)
    end

    describe '#new' do
      it 'is created with a nokogiri trans-unit node' do
        trans_unit_node = xml.xpath('//trans-unit').first
        expect(XLIFF::String.new(trans_unit_node)).to be
      end

      it "can't be created with a string" do
        expect {
          XLIFF::String.new('<file></file>')
        }.to raise_error ArgumentError
      end

      it "can't be created with a node that is not a file node" do
        xml = Oga.parse_xml('<xliff></xliff>')
        trans_unit_node = xml.xpath('/xliff').first
        expect {
          XLIFF::String.new(trans_unit_node)
        }.to raise_error ArgumentError
      end

      it 'have one source' do
        xml = '<trans-unit><target></target></trans-unit>'
        trans_unit_node = Oga.parse_xml(xml).xpath('//trans-unit').first
        expect { XLIFF::String.new(trans_unit_node) }.to raise_error NoElement
      end

      it "don't have multiple sources tag" do
        xml = '<trans-unit>'
        xml += "#{'<source></source>' * 2}<target></target>"
        xml += '</trans-unit>'
        trans_unit_node = Oga.parse_xml(xml).xpath('//trans-unit').first
        expect {
          XLIFF::String.new(trans_unit_node)
        }.to raise_error MultipleElement
      end

      it "don't have multiple targets tag" do
        xml = '<trans-unit>'
        xml += "<source></source>#{'<target></target>' * 2}"
        xml += '</trans-unit>'
        trans_unit_node = Oga.parse_xml(xml).xpath('//trans-unit').first
        expect {
          XLIFF::String.new(trans_unit_node)
        }.to raise_error MultipleElement
      end
    end

    describe '#id' do
      it 'is nil if not defined' do
        xml = '<trans-unit><source></source><target></target></trans-unit>'
        trans_unit_node = Oga.parse_xml(xml).xpath('//trans-unit').first
        expect(XLIFF::String.new(trans_unit_node).id).to be nil
      end

      it 'is the id attribute on trans-unit tag' do
        xml = "<trans-unit id='my id'>"
        xml += '<source></source><target></target>'
        xml += '</trans-unit>'
        trans_unit_node = Oga.parse_xml(xml).xpath('//trans-unit').first
        expect(XLIFF::String.new(trans_unit_node).id.value).to eql('my id')
      end
    end

    describe '#target=' do
      it 'Modify target' do
        trans_unit_node = xml.xpath('//trans-unit').first
        string = XLIFF::String.new(trans_unit_node)
        string.target = 'Hola Mundo'
        expect(string.target).to eq 'Hola Mundo'
      end

      context 'when target do not exist' do
        it 'add a new target' do
          xml = "<trans-unit id='my id'><source>Value</source></trans-unit>"
          trans_unit_node = Oga.parse_xml(xml).xpath('//trans-unit').first
          string = XLIFF::String.new(trans_unit_node)
          string.target = 'Hola Mundo'
          expect(string.target).to eq 'Hola Mundo'
        end
      end
    end

    describe '#source=' do
      it 'Modify source' do
        trans_unit_node = xml.xpath('//trans-unit').first
        string = XLIFF::String.new(trans_unit_node)
        string.source = 'Hola Mundo'
        expect(string.source).to eq 'Hola Mundo'
      end
    end
  end
end
