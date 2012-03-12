# == Schema Information
#
# Table name: areas
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  lat         :float
#  long        :float
#  game_map_id :integer(4)
#  owner_id    :integer(4)
#  color       :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Area do
  pending "add some examples to (or delete) #{__FILE__}"
end
