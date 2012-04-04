class CreateEmailUpdates < ActiveRecord::Migration
  def change
    create_table :email_updates do |t|
      t.string :subject
      t.string :message
      t.date :date_sent

      t.timestamps
    end
  end
end
