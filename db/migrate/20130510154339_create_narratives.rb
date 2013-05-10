class CreateNarratives < ActiveRecord::Migration
  def change
    create_table :narratives do |t|
      t.text :content

      t.timestamps
    end
  end
end
