$LOAD_PATH.push File.dirname(__FILE__) + '/../../rails/init'
$LOAD_PATH.push File.dirname(__FILE__) + '/../../lib'

require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :database => ':memory:'
})
