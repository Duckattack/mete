class CreateDrinksAudit < ActiveRecord::Migration
  def change
    create_table :drinks_audits do |t|
      t.belongs_to :drink, :index => true
      t.decimal :price, :precision => 20, :scale => 2, :default => 0.0
      
      t.timestamps
    end
  end
end
