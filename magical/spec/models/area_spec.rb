# == Schema Information
#
# Table name: areas
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  long       :float
#  lat        :float
#  width      :float
#  height     :float
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Area do
  pending "add some examples to (or delete) #{__FILE__}"
end
