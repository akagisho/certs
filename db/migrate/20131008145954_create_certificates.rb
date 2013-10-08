class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.string :common_name
      t.string :ipv4addr
      t.integer :port
      t.string :organization
      t.string :issuer
      t.datetime :expired_at
      t.datetime :checked_at
      t.text :note

      t.timestamps
    end
  end
end
