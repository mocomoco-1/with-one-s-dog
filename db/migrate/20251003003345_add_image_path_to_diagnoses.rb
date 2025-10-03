class AddImagePathToDiagnoses < ActiveRecord::Migration[7.2]
  def change
    add_column :diagnoses, :image_path, :string
  end
end
