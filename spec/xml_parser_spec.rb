require 'spec_helper'
require './xml_parser'

describe XmlParser do
  subject { described_class.new }

  # Todo:  better test for formatted output
  context "when valid" do
    it "returns correct batch" do
      expect { subject.("feed_test.xml") } .to output.to_stdout
    end
  end

  context "when not valid" do
    it "returns error if file doesn't exists" do
      expect(subject.("worng.xml")).to eq "File doesn't exists"
    end
  end
end