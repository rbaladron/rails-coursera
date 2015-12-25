class CreatePersonalInfos < ActiveRecord::Migration
  def change
    create_table :personal_infos do |t|
      t.float :heigth
      t.float :weigth
      t.references :person, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
