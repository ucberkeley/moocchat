require 'rspec/expectations'

module JsonIncluding
  class JsonIncluding
    def initialize(hash) ; @hash = hash.stringify_keys ; end
    def ==(actual)
      other_hash = JSON.parse(actual).stringify_keys
      other_hash.keys.all? { |k| @hash[k] == other_hash[k] }
    end
    def inspect ; "a JSON object including #{@hash.inspect}" ; end
  end
  def json_including(hash) ;  JsonIncluding.new(hash) ; end
  RSpec::Matchers.define :include_json do |expected|
    match do |actual|
      JsonIncluding.new(expected).should == actual
    end
  end
end

RSpec.configure { |config| config.include JsonIncluding }


