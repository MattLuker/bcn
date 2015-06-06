class Post < ActiveRecord::Base
  acts_as_paranoid
  dragonfly_accessor :image
  dragonfly_accessor :audio

  validates :start_date, allow_nil: true, format: { with: /.*/, message: 'format must look like: 2015-05-25' }
  validates :start_time, allow_nil: true, format: { with: /.*/, message: 'format must look like 05:05' }
  validates :end_date, allow_nil: true, format: { with: /.*/, message: 'format must look like: 2015-05-25' }
  validates :end_time, allow_nil: true, format: { with: /.*/, message: 'format must look like 05:05' }

  belongs_to :user
  has_many :locations
  has_many :comments
  has_many :subscribers, :class_name => "Subscriber", :foreign_key => "post_id"
  has_and_belongs_to_many :communities

  # after_create do
  #   Log.create({post: self, action: "created"})
  # end
  #
  # after_update do
  #   Log.create({post: self, action: "updated"})
  # end


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
end
