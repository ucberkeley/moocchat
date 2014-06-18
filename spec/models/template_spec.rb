require 'spec_helper'

describe Template do
  describe 'is valid' do
    it 'with a valid URL' do
      Template.new(:name => 'x', :url => 'http://google.com', :html => nil).should be_valid
    end
    it 'with nonblank HTML' do
      Template.new(:name => 'x', :url => nil, :html => '<!DOCTYPE html><html></html>').should be_valid
    end
  end
  describe 'is invalid' do
    it 'with no name' do
      Template.new(:url => 'http://google.com').should_not be_valid
    end
    it 'with invalid URL' do
      Template.new(:name => 'x', :url => 'not! a URL').should_not be_valid
    end
    it 'with both nonblank URL and nonblank HTML' do
      Template.new(:name => 'x', :url => 'http://google.com', :html => '<html></html>').should_not be_valid
    end
  end
end
