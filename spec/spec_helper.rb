$LOAD_PATH.push File.dirname(__FILE__) + '/../rails/init'
$LOAD_PATH.push File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.push File.dirname(__FILE__) + '/include'

require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :database => 'spec/test.sqlite3'
})

require 'factories'
require 'schema'
