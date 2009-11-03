require "#{File.dirname(__FILE__)}/spec_helper"
require "spec/mocks"

describe 'alphabet' do
  before(:each) do
    @alphabet = Alphabet.new(:name => 'test user')
  end

  specify 'be valid' do
    @alphabet.should be_valid
  end
  
  specify 'import letters' do
    @alphabet.save!
    @alphabet.import_letters("alpha bravo charlie dozer echo")
    @alphabet.letters.size.should == 5
  end

  specify 'spell' do
    @alphabet.save!
    @alphabet.import_letters("alpha bravo charlie dozer echo")
    @alphabet.spell("cab").should == "charlie alpha bravo"
    @alphabet.spell("cabo").should == "charlie alpha bravo o"
    @alphabet.spell("caboose").should == "charlie alpha bravo o o s echo"
    @alphabet.spell("blue ox").should == "bravo l u echo / o x"
  end
  
  specify 'words' do
    @alphabet.save!
    @alphabet.import_letters("alpha bravo charlie dozer echo")
    @alphabet.words.should == "alpha bravo charlie dozer echo"
  end
  
  specify 'generate permalink' do
    @alphabet.permalink.should be_nil
    @alphabet.save
    @alphabet.permalink.should == "test_user"
    
    @alphabet = Alphabet.new(:name => 'TEST USER')
    @alphabet.save
    @alphabet.permalink.should == "test_user_1"
    
    @alphabet = Alphabet.new(:name => 'TEST USER!')
    @alphabet.save
    @alphabet.permalink.should == "test_user_2"

    @alphabet = Alphabet.new(:name => '!#%CRAZY MUTHAFUCKIN ? SHIT -- __ -')
    @alphabet.save
    @alphabet.permalink.should == "crazy_muthafuckin_shit"
    
    @alphabet = Alphabet.new(:name => '2 LEGIT_2 QUIT')
    @alphabet.save
    @alphabet.permalink.should == "2_legit_2_quit"
  end

  specify 'require a name' do
    @alphabet = Alphabet.new
    @alphabet.should_not be_valid
    @alphabet.errors[:name].should include("Name must not be blank")
  end
end
