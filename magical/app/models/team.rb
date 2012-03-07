class Team < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, 
                   uniqueness: {case_sensitive: false},
                   length: {minimum: 1} # Unsure if this is needed

  has_many :members, :class_name => 'User'
#  has_one :commander, :class_name => 'User'
end
