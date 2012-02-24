class CreateAuthentications < ActiveRecord::Migration
  def self.change
    create_table :authentications do |t|
      t.string :provider, :uid, :token, :secret, :uemail, :uname, :link
      t.references :identity
      t.timestamps
    end
  end
end