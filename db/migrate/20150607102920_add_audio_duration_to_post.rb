class AddAudioDurationToPost < ActiveRecord::Migration
  def change
    add_column :posts, :audio_duration, :integer
    add_column :posts, :explicit, :boolean
  end
end
