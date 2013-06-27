class Stats
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  
    attr_accessor :male, :female, :age1, :age2, :country, :team, :sort
	
	
  def persisted?
    false
  end
  



end