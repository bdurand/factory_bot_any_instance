require 'minitest/autorun'
require 'active_record'

require File.expand_path("../../lib/factory_bot_any_instance.rb", __FILE__)

ActiveRecord::Base.establish_connection("adapter" => "sqlite3", "database" => ":memory:")

module Test
  def self.create_tables
    Model.connection.create_table(:models) do |t|
      t.string :name
      t.integer :parent_id
    end unless Model.table_exists?
  end
  
  def self.drop_tables
    Model.connection.disconnect!
  end
  
  class Model < ActiveRecord::Base
    belongs_to :parent, :class_name => "Test::Model"
  end
end

Test.create_tables

Minitest.after_run do
  Test.drop_tables
end

class Minitest::Spec
  include FactoryBot::Syntax::Methods
  
  before do
    clear_instances
  end
end
