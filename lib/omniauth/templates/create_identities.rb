class CreateIdentities < ActiveRecord::Migration
  def self.change
    create_table :identities do |t|
      t.string :email, :name, :password_digest
      t.timestamps
    end
  end
end