require 'rubygems'
require 'mongrel'
require 'active_support'
require 'md5'

module AppServer
  def self.environment
    'development'
  end
end

require 'xml'

