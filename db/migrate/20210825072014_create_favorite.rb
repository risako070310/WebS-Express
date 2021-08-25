class CreateFavorite < ActiveRecord::Migration[6.1]
  def change
    add_column :histories, :favorite, :boolean, default: false
  end
end
