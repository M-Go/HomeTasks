class CreatePetitions < ActiveRecord::Migration
  def change
    create_table :petitions do |t|
      t.string :title
      t.string :description
    end
  end
end
