class ChangeAudioToDragonfly < ActiveRecord::Migration
  def change
    remove_column :posts, :audio_url, :string
    remove_column :posts, :audio_duration, :integer

    add_column :posts, :audio, :string
    add_column :posts, :audio_uid, :string
    add_column :posts, :audio_name, :string
  end
end
