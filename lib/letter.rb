class Letter
  include DataMapper::Resource

  property :id,         Serial
  property :character,  String
  property :word,       String
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :alphabet
  validates_present :word, :character
  
  def clean_word      
    self.word.
    gsub(/^.-/, ""). # protect against words that start with two bad chars.. can't remember why.
    gsub("e'", "é").
    gsub("c,", "ç").
    gsub("i`", "ì").
    gsub("n~", "ñ").
    gsub("a'", "á").
    gsub('"a', "ä").
    gsub('a"', "ä")
  end
  
  def fix_accents
    word.gsub!("e'", "é")
    save!
  end

end