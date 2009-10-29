require "#{File.dirname(__FILE__)}/spec_helper"

describe 'query' do
  before(:each) do
    @query = Query.new(:phrase => 'abc')
  end

  specify 'should be valid' do
    @query.should be_valid
  end

  specify 'should require a phrase' do
    @query = Query.new
    @query.should_not be_valid
    @query.errors[:phrase].should include("Phrase must not be blank")
  end
  
  specify 'should increment hit count on save' do
    @query.hits.should be_nil
    @query.save
    @query.hits.should == 1
    @query.save
    @query.hits.should == 2
  end

end