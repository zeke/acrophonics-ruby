class Letter
  include DataMapper::Resource

  property :id,         Serial
  property :character,  String
  property :word,       String
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :alphabet
  validates_present :name
  
  def clean_word  
    return self.word unless self.word[1,1] == "-"
    return self.word[2,(self.word.size-2)]
  end

end
