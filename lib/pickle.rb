require 'rubygems'
require 'spec'

module Spec::Example::ExampleGroupMethods
  alias scenario example
  alias background before
end

module Spec::DSL::Main
  alias feature describe
end

if ENV['RAILS_ENV']
  gem 'rspec-rails'
  require 'spec/rails'

  module Spec::Rails::Example
    class AcceptanceExampleGroup < ActionController::IntegrationTest
      include ActionController::RecordIdentifier
      Spec::Example::ExampleGroupFactory.register(:acceptance, self)
    
      def method_missing(sym, *args, &block)
        return Spec::Matchers::Be.new(sym, *args)  if sym.to_s =~ /^be_/
        return Spec::Matchers::Has.new(sym, *args) if sym.to_s =~ /^have_/
        super
      end
    end
  end

  class ActionController::IntegrationTest < ActiveSupport::TestCase
    def initialize(name)
      super
    end
  end
end