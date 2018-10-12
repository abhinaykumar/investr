class CreateSources < ActiveRecord::Migration[5.2]
  def change
    create_table :sources do |t|
      t.string :email
      t.string :subject

      t.timestamps
    end
  end
end
