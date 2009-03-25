class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :document_file_name, :string
      t.column :document_content_type, :string
      t.column :document_file_size, :integer
      t.column :document_updated_at, :datetime
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by_id, :integer
      t.column :updated_by_id, :integer
      t.column :lock_version, :integer
      t.column :site_id, :integer
    end

    create_table :downloads_groups, :id => false do |t|
      t.column :download_id, :integer
      t.column :group_id, :integer
    end
  end

  def self.down
    drop_table :downloads
    drop_table :downloads_groups
  end
end