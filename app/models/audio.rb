class Audio < ActiveRecord::Base
  dragonfly_accessor :audio
  #after_save :set_audio_duration

  validates :audio, presence: true

  validates_property :ext, of: :audio,
                     in: ['mp3', 'ogg', 'wmv', 'm2a', 'midi', 'mpg', 'wav', 'mp4', 'm4a'],
                     if: :audio_changed?
  validates_property :mime_type, of: :audio, in: ['audio/mpeg', 'audio/ogg', 'audio/midi', 'audio/mpeg3', 'audio/wav',
                                                  'audio/mp4a-latm', 'application/ogg', 'application/octet-stream'], if: :audio_changed?

  belongs_to :post

  def set_audio_duration
    require 'taglib'

    file_path = Rails.root.join('public', 'system', 'dragonfly', Rails.env, audio_uid).to_s
    TagLib::FileRef.open(file_path) { |f| self.audio_duration = f.audio_properties.length }
  end
end
