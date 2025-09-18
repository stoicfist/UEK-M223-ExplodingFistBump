class AddFieldsToSessions < ActiveRecord::Migration[8.0]
  def change
    add_reference :sessions, :user, null: false, foreign_key: true
    add_column :sessions, :user_agent, :string
    add_column :sessions, :ip_address, :string
  end
end
