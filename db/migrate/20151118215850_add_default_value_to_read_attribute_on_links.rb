class AddDefaultValueToReadAttributeOnLinks < ActiveRecord::Migration
  def up
    change_column :links, :read, :boolean, :default => false
  end

  def down
    change_column :links, :read, :boolean, :default => nil
  end
end
