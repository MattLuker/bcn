class Post < ActiveRecord::Base
  acts_as_paranoid
  dragonfly_accessor :image
  dragonfly_accessor :audio

  validates :start_date, allow_nil: true, format: { with: /.*/, message: 'format must look like: 2015-05-25' }
  validates :start_time, allow_nil: true, format: { with: /.*/, message: 'format must look like 05:05' }
  validates :end_date, allow_nil: true, format: { with: /.*/, message: 'format must look like: 2015-05-25' }
  validates :end_time, allow_nil: true, format: { with: /.*/, message: 'format must look like 05:05' }

  validates_property :ext, of: :image, in: ['jpeg', 'jpg', 'png', 'gif', 'svg', 'svgz'], if: :image_changed?
  validates_property :mime_type, of: :image,
                     in: ['image/jpeg', 'image/png', 'image/gif', 'image/svg+xml', 'image/svg'],
                     if: :image_changed?
  validates_property :format, of: :image, in: ['jpeg', 'png', 'gif', 'svg', 'svgz'], if: :image_changed?

  validates_property :ext, of: :audio,
                     in: ['mp3', 'ogg', 'wmv', 'm2a', 'midi', 'mpg', 'wav', 'mp4', 'm4a'],
                     if: :audio_changed?
  validates_property :mime_type, of: :audio, in: ['audio/mpeg', 'audio/ogg', 'audio/midi', 'audio/mpeg3', 'audio/wav',
                                                  'audio/mp4a-latm', 'application/ogg'], if: :audio_changed?


  belongs_to :user
  has_many :locations
  has_many :comments
  has_many :subscribers, :class_name => "Subscriber", :foreign_key => "post_id"
  has_and_belongs_to_many :communities, before_add: :inc_posts_count, before_remove: :dec_posts_count


  before_save :set_audio_duration

  def as_json(options={})
    super(:only => [
        :id,
        :title,
        :description,
        :start_date,
        :end_date
      ],
      :include => {
        :locations => {
          :only => [
            :id,
            :lat,
            :lon,
            :name,
            :address,
            :city,
            :state,
            :postcode,
            :county,
            :country
          ]
        },
        :communities => {
          :only => [
            :id,
            :name,
            :description,
            :home_page,
            :color
          ]
        },
        :user => {
            :only => [
                :email,
                :first_name,
                :last_name,
                :username
            ]
        }
      }
    )
  end

  def get_og_attrs(url)

    data = {}
    begin
      doc = Nokogiri::HTML(open(url, 'User-Agent' => 'ruby'))

      doc.css('meta').each do |node|
        case node['property']
          when 'og:title'
            puts "title: #{node['content']}"
            data[:og_title] = node['content']
          when 'og:image'
            puts "image: #{node['content']}"
            data[:og_image] = node['content']
          when 'og:url'
            puts "url: #{node['content']}"
            data[:og_url] = node['content']
          when 'og:description'
            puts "description: #{node['content']}"
            data[:og_description] = node['content']
        end
        # Grab the rest of the attributes as best we can.
        unless data[:og_description]
          if node['name'] == 'description'
            data[:og_description] = node['content']
          end
        end
        data[:og_url] = url unless data[:og_url]
        data[:og_image] = '//:0' unless data[:og_image]
        data[:og_title] = doc.css('title').text unless data[:og_title]
      end
    rescue
      data[:og_error] = 'Sorry no preview available.'
      data[:og_url] = url
      data[:og_image] = '//:0'
      data[:og_title] = url
      data[:og_description] = ' '
    end
    data
  end

  def create_location(params)
    loc = Location.new.set_location_attrs(Location.new, params)
    self.locations << loc
  end

  def set_audio_duration
    require 'taglib'

    if audio
      file_path = Rails.root.join('public', 'system', 'dragonfly', Rails.env, audio_uid).to_s
      TagLib::FileRef.open(file_path) { |f| self.audio_duration = f.audio_properties.length }
    end
  end

  private
  def inc_posts_count(model)
    puts "model.inspect: #{model.inspect}"
    Community.increment_counter('posts_count', model.id)
  end

  def dec_posts_count(model)
    puts "dec_posts_count: #{model.inspect}"
    Community.decrement_counter('posts_count', model.id)
  end
end
