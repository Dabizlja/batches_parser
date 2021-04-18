require 'nokogiri'
require 'json'
require_relative 'external_service'

class XmlParser
  attr_reader :batches

  BATCH_SIZE = 5242880.0

  def initialize
    @batches = []
  end

  def call(file)
    return "File doesn't exists" unless File.exists?(file)
    parse_xml(file)
    print_infromation
  end

  private

  def get_file_content(file)
    Nokogiri::XML(File.open(file))
  end

  def parse_xml(file)
    get_file_content(file).xpath("//item").each do |item|
      add_product(item)
    end
  end

  def add_product(item)
    id = item.at_xpath('g:id')&.text
    title = item.at_xpath('title')&.text
    description = item.at_xpath('description')&.text&.gsub(/<\/?[^>]*>/, "")
    batches << { id: id, title: title, description: description }
  end

  def print_infromation
    external_service = ExternalService.new
    batches.each_slice(get_slice_number) do |batch|
      external_service.(batch)
    end
  end

  def batches_number
    (batches.to_json.bytesize / BATCH_SIZE).to_i
  end

  def get_slice_number
    (batches.size / batches_number) + 1 rescue 1
  end
end

p XmlParser.new.("feed.xml")