require "#{File.dirname(__FILE__)}/spec_helper"

describe 'app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  describe '/' do 
    specify 'show the default index page' do
      get '/'
      last_response.should be_ok
    end
  end
  
  describe '/spellpost' do
    specify 'redirect' do
      post '/spellpost', {:phrase => "dog"}
      last_response.should be_redirect
    end
  end
  
  describe '/spell/:phrase' do 
    specify 'show spelling for all alphabets' do
      @alphabet = Alphabet.create!(:name => "Español")
      @alphabet.import_letters("animo bella cojones dedo edificio")
      @alphabet = Alphabet.create!(:name => "English")
      @alphabet.import_letters("ankle ball cooking double eagle")
      Alphabet.count.should == 2
      get '/spell/bad'
      last_response.body.should include("English")
      last_response.body.should include("bella animo dedo")
      last_response.body.should include("Español")
      last_response.body.should include("ball ankle double")
      last_response.should be_ok
    end
    
    specify "show proper header" do
      pending
    end
    
    specify 'save query' do
      Query.count.should == 0
      get '/spell/dog'
      Query.count.should == 1
      Query.first.phrase.should == "dog"
    end
  end
  
  describe 'alphabets/:permalink' do
    specify 'show alphabet' do
      @alphabet = mock(Alphabet, :id => 10, :name => "Phoney Alpha", :year => "1955", :notes => "this is fake", :words => %w(alpha bravo charlie))
      Alphabet.should_receive(:first).once.and_return(@alphabet)
      @alphabet.should_receive(:notes).once.and_return('this is fake')
      @alphabet.should_receive(:year).once.and_return('1955')
      @alphabet.should_receive(:words).once.and_return('alpha bravo charlie')
      @alphabet.should_receive(:permalink).once.and_return('phoney_alpha')
      get '/alphabets/phoney_alpha'
      last_response.should be_ok
      last_response.body.should include("1955")
      last_response.body.should include("this is fake")
      last_response.body.should include("alpha")
    end
  end


end
