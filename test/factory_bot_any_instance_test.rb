require File.expand_path('../test_helper.rb', __FILE__)

FactoryBot.define do
  factory :test, class: Test::Model do
    name "Foo"
  end
  
  factory :child, class: Test::Model do
    name "Child"
    parent { any(:test) }
  end 
end

describe FactoryBot::AnyInstance do
    
  it "should not interfere with creating instances" do
    instance_1 = create(:test)
    instance_2 = create(:test)
    assert instance_2.id > instance_1.id

    any_instance_1 = any(:test)
    assert any_instance_1.id > instance_2.id
    
    instance_3 = create(:test)
    assert instance_3.id > any_instance_1.id
    
    any_instance_2 = any(:test)
    assert any_instance_2.id == any_instance_1.id
  end
  
  it "should clear memoized instances" do
    any_instance_1 = any(:test)
    any_instance_2 = any(:test)
    assert any_instance_2.id == any_instance_1.id
    
    clear_instances
    
    any_instance_3 = any(:test)
    any_instance_4 = any(:test)
    assert any_instance_3.id == any_instance_4.id
    assert any_instance_3.id != any_instance_2.id
  end
  
  it "should reuse instances inside of factories" do
    instance_1 = create(:child)
    instance_2 = create(:child)
    assert instance_1.parent.id == instance_2.parent.id
  end
  
  it "should not interfered with the build method" do
    instance = build(:child)
    assert instance.attributes, {"id" => nil, "name" => "Child", "parent_id" => any(:test).id}
  end
  
  it "should not interfered with the build method" do
    assert attributes_for(:child), {"id" => nil, "name" => "Child", "parent_id" => any(:test).id}
  end
  
end
