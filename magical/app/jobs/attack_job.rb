class AttackJob < Struct.new(:from_area_id, :to_area_id, :user_id, :minion_group_on_area_id)
  def perform
    Rails.logger.error(user_id)
    puts user_id

    Rails.logger.info("Performing AttackJob")
    puts "Attack info:"
    puts @user.to_s() + " from " + from_area_id.to_s() + " to " + to_area_id
    
    @user = User.find(user_id)
    @user.execute_attack(from_area_id, to_area_id, user_id, minion_group_on_area_id)
  end
end