class AddAudioAttrsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :audio_url, :string
    add_column :posts, :audio_duration, :integer

    add_index :posts, :audio_url
  end
end
