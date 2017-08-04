require 'English'
APP_ROOT = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(APP_ROOT, 'lib'))
require 'guide'
guide = Guide.new('restaurants.txt')
guide.launch
