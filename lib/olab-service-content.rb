require 'ostruct'

# Create an object to store content related to our services, with defaults.
ServiceContent = Hash.new(OpenStruct.new({
  'title'   => 'Turn On',
  'slogan'  => 'The Power of Feedback',
  'image'   => "screenshot.png",
  'partial' => 'opinionlab'
}))

# Add the 'analytics' service content
ServiceContent['analytics'] = OpenStruct.new({
  'title'   => "Analytics",
  'slogan'  => "Visualize Your Feedback",
  'image'   => "screenshot.png",
  'partial' => 'analytics'
})
