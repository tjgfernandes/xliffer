require 'spec_helper'
require 'oga'

module XLIFFer
  describe XLIFF::File do
    describe '#new' do
      it 'is created with a oga file node' do
        file_node = Oga.parse_xml('<file></file>').xpath('/file').first
        expect(XLIFF::File.new(file_node)).to be
      end

      it "can't be created with a string" do
        expect { XLIFF::File.new('<file></file>') }.to raise_error ArgumentError
      end

      it "can't be created with a node that is not a file node" do
        xml = Oga.parse_xml('<xliff><file></file></xliff>')
        file_node = xml.xpath('/xliff').first
        expect { XLIFF::File.new(file_node) }.to raise_error ArgumentError
      end
    end

    describe '#original' do
      it 'is nil if not defined' do
        xml = Oga.parse_xml('<xliff><file></file></xliff>')
        file_node = xml.xpath('//file').first
        expect(XLIFF::File.new(file_node).original).to be nil
      end

      it 'is the original attribute on file tag' do
        xml_text = '<xliff><file original="neat file.c"></file></xliff>'
        xml = Oga.parse_xml(xml_text)
        file_node = xml.xpath('//file').first
        expect(XLIFF::File.new(file_node).original).to eql('neat file.c')
      end
    end

    describe '#source_language' do
      it 'is nil if not defined' do
        xml = Oga.parse_xml('<xliff><file></file></xliff>')
        file_node = xml.xpath('//file').first
        expect(XLIFF::File.new(file_node).source_language).to be nil
      end

      it 'is the original attribute on file tag' do
        xml_text = '<xliff><file source-language="en"></file></xliff>'
        xml = Oga.parse_xml(xml_text)
        file_node = xml.xpath('//file').first
        expect(XLIFF::File.new(file_node).source_language).to eql('en')
      end
    end

    describe '#target_language' do
      it 'is nil if not defined' do
        xml = Oga.parse_xml('<xliff><file></file></xliff>')
        file_node = xml.xpath('//file').first
        expect(XLIFF::File.new(file_node).target_language).to be nil
      end

      it 'is the original attribute on file tag' do
        xml_text = '<xliff><file target-language="fr"></file></xliff>'
        xml = Oga.parse_xml(xml_text)
        file_node = xml.xpath('//file').first
        expect(XLIFF::File.new(file_node).target_language).to eql('fr')
      end
    end

    describe 'attribute accessors' do
      let(:subject) do
        xml = Oga.parse_xml('<xliff><file></file></xliff>')
        XLIFF::File.new xml.xpath('//file').first
      end

      describe 'source_language=' do
        it 'changes the source language' do
          xml_text = '<xliff><file source-language="fr"></file></xliff>'
          file_node = Oga.parse_xml(xml_text).xpath('//file').first
          subject = XLIFF::File.new file_node
          subject.source_language = 'en'
          expect(subject.source_language).to eq('en')
        end

        it "adds source language if don't exist" do
          subject.source_language = 'en'
          expect(subject.source_language).to eq('en')
        end
      end

      describe 'target_language=' do
        it 'changes the target language' do
          xml_text = '<xliff><file target-language="fr"></file></xliff>'
          file_node = Oga.parse_xml(xml_text).xpath('//file').first
          subject = XLIFF::File.new file_node
          subject.target_language = 'en'
          expect(subject.target_language).to eq('en')
        end

        it "adds target language if don't exist" do
          subject.target_language = 'en'
          expect(subject.target_language).to eq('en')
        end
      end
    end

    describe 'string accessors' do
      let(:xml) do
        <<-EOF
        <file>
          <trans-unit id="hello">
            <source>Hello World</source>
            <target>Bonjour le monde</target>
          </trans-unit>
          <trans-unit id="bye">
            <source>Bye World</source>
            <target>Au revoir le monde</target>
          </trans-unit>
          <trans-unit id="missing">
            <source>Missing</source>
          </trans-unit>
        </file>
        EOF
      end

      let(:subject) do
        XLIFF::File.new(Oga.parse_xml(xml).xpath('//file').first)
      end

      describe '[]' do
        it 'gets the string with this id' do
          expect(subject['hello'].target.inner_text).to eq('Bonjour le monde')
        end

        it 'returns nil if no string found' do
          expect(subject['non-existent id']).to be_nil
        end
      end

      describe '[]=' do
        it 'changes the string target' do
          subject['hello'] = 'changed text'
          expect(subject['hello'].target).to eq('changed text')
        end

        it "adds a text if don't exist" do
          subject['missing'] = 'new text'
          expect(subject['missing'].target).to eq('new text')
        end
      end
    end

    describe '#strings' do
      let(:trans_unit) do
        <<-EOF
        <trans-unit id="my id">
          <source>Hello World</source>
          <target>Bonjour le monde</target>
        </trans-unit>
        EOF
      end
      it 'is an array ' do
        xml = Oga.parse_xml('<xliff><file></file></xliff>')
        file_node = xml.xpath('//file').first
        expect(XLIFF::File.new(file_node).strings).to be_kind_of(Array)
      end

      it 'can be empty' do
        xml = Oga.parse_xml('<xliff><file></file></xliff>')
        file_node = xml.xpath('//file').first
        expect(XLIFF::File.new(file_node).strings).to be_empty
      end

      it 'should have a string' do
        xml = Oga.parse_xml("<xliff><file>#{trans_unit}</file></xliff>")
        file_node = xml.xpath('//file').first
        expect(XLIFF::File.new(file_node).strings.size).to eql(1)
      end

      it 'should have multiple strings' do
        xml_text = "<xliff><file>#{trans_unit * 10}</file></xliff>"
        xml = Oga.parse_xml(xml_text)
        file_node = xml.xpath('//file').first
        expect(XLIFF::File.new(file_node).strings.size).to eql(10)
      end
    end
  end
end
