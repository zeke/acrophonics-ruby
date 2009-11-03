class Alphabet
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String
  property :permalink,  String
  property :language,   String
  property :notes,      Text  
  property :year,       String
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :letters
  validates_present :name
  validates_is_unique :permalink
  
  before :create, :generate_permalink
  before :save, :generate_permalink
  
  def spell(phrase)
    spelling = []
    phrase.strip.downcase.split("").each do |character|
      word = self.letters.first(:character => character).clean_word rescue nil
      word ||= character.dup # Set to character first to be safe.
      word = "/" if word == " "
      spelling << word
    end
    spelling.join(" ")
  end
  
  def import_letters(words)
    words.strip.downcase.split(" ").each do |word|
      self.letters.create!(:character => word[0,1], :word => word)
    end
  end
  
  def words
    self.letters.map{|letter| letter.word }.join(" ")
  end
  
  def generate_permalink(suffix=0)
    self.permalink = self.name.dup.
    gsub(/[^\x00-\x7F]+/, '').
    gsub(/[^-\w\d]+/sim, "_").
    gsub(/-+/sm, "_").
    gsub(/^-?(.*?)-?$/, '\1').
    gsub(/^\_*/, '').
    gsub(/\_*$/, '').
    downcase
    
    # Add suffix
    self.permalink += "_#{suffix}" unless suffix == 0
    
    # If the permalink is taken, increment the suffix integer and try again
    existing = Alphabet.first(:permalink => self.permalink)
    self.generate_permalink(suffix+1) if existing && existing.id != self.id
    
    true
  end

end
