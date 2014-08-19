class CreateCounterinfos < ActiveRecord::Migration
  def change
    create_table :counterinfos do |t|
      t.text :content

      t.timestamps
    end
  end
end
