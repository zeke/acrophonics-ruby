class Alphabet
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String
  property :language,   String
  property :notes,      Text  
  property :year,       String
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :letters
  validates_present :name
  
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

end
