# == Schema Information
#
# Table name: game_maps
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  adjacency_list :text
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe GameMap do
  pending "add some examples to (or delete) #{__FILE__}"
end
