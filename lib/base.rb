require 'rubygems'
require 'active_support'
module Server
  mattr_accessor :environment

  def self.root
    File.dirname(__FILE__) + '/..'
  end
end

$: << File.join(Server.root, 'app', 'models')

require 'lib/controller'
