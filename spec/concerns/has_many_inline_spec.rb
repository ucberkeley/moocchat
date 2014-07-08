require 'spec_helper'

DUMMY_DB = {:adapter => 'sqlite3', :database => ':memory:'}

class DummyDatabase < ActiveRecord::Base
  # force this class to have its own DB connection
  def self.abstract_class? ; true ;  end
  establish_connection DUMMY_DB
end

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :test_owners, :force => true do |t| ; t.text :things ; end
    create_table :things, :force => true do |t| ; end
  end
end

describe HasManyInline, :pending => true do

  before :all do ; setup_db ; end

  class Thing < DummyDatabase
  end
  class TestOwner < DummyDatabase
    include HasManyInline
    has_many_inline :things
  end

  it 'provides has_many_inline method' do
    TestOwner.should respond_to :has_many_inline
  end
  describe 'getter' do
    before :all do ; TestOwner.send(:has_many_inline, :things) ; end
    it 'exists' do
      TestOwner.new.should respond_to :things
    end
    it 'serializes a record' do
      the_things = Array.new(3) { Thing.create! }
      owner = TestOwner.new
      owner.things = the_things
      owner[:things].should == the_things.map(&:id)
    end
  end
  describe 'provides' do
    describe 'getter' do
      subject { TestOwner.new.things }
      it { should be_a_kind_of Array }
      it { should be_empty }
    end
    describe 'setter' do
      subject { TestOwner.new }
      it { should respond_to('things=') }
    end
  end
end
