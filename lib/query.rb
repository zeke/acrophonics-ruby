class Query
  include DataMapper::Resource

  property :id,         Serial
  property :phrase,     Text
  property :hits,       Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_present :phrase

  before :save, :update_hit_count

  def update_hit_count
    self.hits ||= 0 # In case it's nil
    self.hits +=1
  end

end
