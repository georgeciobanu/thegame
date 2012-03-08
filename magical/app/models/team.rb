# == Schema Information
#
# Table name: teams
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Team < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true, 
                   uniqueness: {case_sensitive: false},
                   length: {minimum: 1}

  has_many :members, :class_name => 'User'
#  has_one :commander, :class_name => 'User'
end