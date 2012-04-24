class EmailUpdate < ActiveRecord::Base
end
# == Schema Information
#
# Table name: email_updates
#
#  id         :integer(4)      not null, primary key
#  subject    :string(255)
#  message    :string(255)
#  date_sent  :date
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

