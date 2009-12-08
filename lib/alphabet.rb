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
  
  before :create do
    generate_permalink
  end
  before :save, :generate_permalink
  
  def spell(phrase)
    spelling = []
    # Convert non-alphanumeric characters to a space, then removes excess whitespace.
    phrase = phrase.gsub(/\W/, " ").gsub("_", " ").split(" ").join(" ")
    phrase.strip.downcase.split("").each do |character|
      word = self.letters.first(:character => character).clean_word rescue nil
      # If a word is not found, use the letter instead..
      word ||= character.dup
      # Show a delimiter between words..
      word = "/" if word == " "
      spelling << word
    end
    spelling.join(" ")
  end
  
  # Shouldn't have to add the alphabet_id part, but heroku or postgres is not 
  # making the relation happen without it. WTF?
  def import_letters(alphabet_string)
    alphabet_string.strip.downcase.split(" ").each do |w|
      self.letters.create!(:character => w[0,1], :word => w, :alphabet_id => self.id)
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
    
    # Add suffix (only if being called for a second/third/fourth.. time)
    self.permalink += "_#{suffix}" unless suffix == 0
    
    # If the permalink is taken, increment the suffix integer and try again
    existing = Alphabet.first(:permalink => self.permalink)
    self.generate_permalink(suffix+1) if existing && existing.id != self.id
    
    true
  end

end
