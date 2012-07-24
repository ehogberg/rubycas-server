require 'ostruct'

# Create an object to store content related to our services, with defaults.
ServiceContent = Hash.new(OpenStruct.new({
  'title'  => 'OpinionLab',
  'slogan' => 'fallback slogan here',
  'image'  => "screenshot.png"
}))

# Add the 'analytics' service content
ServiceContent['analytics'] = OpenStruct.new({
  'title'  => "Analytics",
  'slogan' => "visualize your feedback",
  'image'  => "screenshot.png"
})
