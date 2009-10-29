require "#{File.dirname(__FILE__)}/spec_helper"

describe 'alphabet' do
  before(:each) do
    @alphabet = Alphabet.new(:name => 'test user')
  end

  specify 'should be valid' do
    @alphabet.should be_valid
  end
  
  specify 'should import letters' do
    @alphabet.save!
    @alphabet.import_letters("alpha bravo charlie dozer echo")
    @alphabet.letters.size.should == 5
  end

  specify 'should spell' do
    @alphabet.save!
    @alphabet.import_letters("alpha bravo charlie dozer echo")
    @alphabet.spell("cab").should == "charlie alpha bravo"
    @alphabet.spell("cabo").should == "charlie alpha bravo o"
    @alphabet.spell("caboose").should == "charlie alpha bravo o o s echo"
    @alphabet.spell("blue ox").should == "bravo l u echo / o x"
  end

  specify 'should require a name' do
    @alphabet = Alphabet.new
    @alphabet.should_not be_valid
    @alphabet.errors[:name].should include("Name must not be blank")
  end
end
