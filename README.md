This gem provides helper methods to [FactoryGirl](https://github.com/thoughtbot/factory_girl) to support memoization and reuse of factory created instances.

The goal is to clean up test code and speed up performance where your tests use models that have required associations but where those associations are not themselves referenced in the tests.

### Example

For instance, suppose you have factories for a BlogPost model which has many Comments and each comment requires an associated User:

```ruby
FactoryGirl.define do
  factory :blog_post_ do
    title "Test Post"
    ...
  end
  
  factory :comment do
    body "Test comment"
    blog_post
    user
  end
  
  factory :user do
    name "Test User"
    ...
  end
end
```

Now if you need 30 comments for a blog post in your test:

```ruby
  post = create(:blog_post)
  create_list(:comment, :blog_post => post)
```

However, this will create 30 unique User records which could be expensive if the User record has it's own required associations or performs several callbacks. A simple solution is to provide a single User record for all the Comments:

```ruby
  post = create(:blog_post)
  user = create(:user)
  create_list(:comment, :blog_post => post, :user => user)
```

This gem provides an extension to the FactoryGirl DSL so that you can accomplish the same thing at the factory level. This can help keep your test code clean since you don't have to declare additional variables that aren't relevant to the test.

```ruby
  post = create(:blog_post)
  create_list(:comment, :blog_post => post, :user => any(:user))
```

The `any` method will return an object using the specified factory with default attributes. On the first invocation of `any` it will create the object; on subsequent calls it will return the same object.

You can also use the `any` method in your factory definitions so that the factory will re-use an associated record by default. This can make your tests much cleaner when the models get more complicated with layers of required associations. It can also help speed up a test suite that's already been written and gotten slower without having to rewrite every test case.

```ruby
FactoryGirl.define do
  factory :comment do
    body "Test comment"
    blog_post
    user { any(:user) }
  end
end
```

Note that you must include the `any` call inside a block in your factory so that it will only get evaluated at runtime. Be careful with this method, though, because it could slow down your test suite if you make use of the `build` method because the `any` defined objects will be inserted into the database.

### Cleaning Up

You *MUST* cleanup the instantiated instances between tests or you will have random artifacts spanning them. Most test suites clear the database between runs so these artifacts will also be completely invalid. To do this you must call the `clear_instances` method. You can set up your test suite to do this before every test.

#### RSpec

Add this to your `spec_helper.rb` file:

```ruby
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before do
    clear_instances
  end
end
```

#### Minitest::Spec

Add this to your `test_helper.rb` file:

```ruby
class Minitest::Spec
  include FactoryGirl::Syntax::Methods
  
  before do
    clear_instances
  end
end
```

#### ActiveSupport::TestCase

Add this to your `test_helper.rb` file:

```ruby
class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  
  setup do
    clear_instances
  end
end
```

#### Minitest::Unit

Call `FactoryGirl.clear_instances` in the setup method on all your test classes.

### Helper Methods

All of these examples assume you've included `FactoryGirl::Syntax::Methods` in your test helper. This gem adds the `any` and `clear_instances` methods to those helpers. If you don't include the helper methods, you must call `FactoryGirl.any` and `FactoryGirl.clear_instances` instead.

### Parallelizing

This code is not compatible with multithreaded test runners. It will work fine with multi process test runners.
