class Badge < ActiveRecord::Base
  dragonfly_accessor :image
  attr_accessor :image_web_url

  validates :rules, format: { without: /.*destroy.*/ }

  validates_property :mime_type, of: :image,
                     in: ['image/jpeg', 'image/png', 'image/gif', 'image/svg+xml', 'image/svg', 'application/octet-stream'],
                     if: :image_changed?
  validates_property :format, of: :image, in: ['jpeg', 'png', 'gif', 'svg', 'svgz'], if: :image_changed?

  has_and_belongs_to_many :users

  def as_json(options={})
    self.image_web_url = self.image.url if self.image
    super(methods: :image_web_url, :only => [
                                     :id,
                                     :name,
                                     :description,
                                     :rules,
                                     :image_name,
                                     :image_web_url,
                                     :created_at
                                 ], :include => {
                                      :users => { only: [:id, :username]}
                                 }
    )
  end
end