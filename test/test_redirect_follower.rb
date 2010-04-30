require 'helper'

class TestRedirectFollower < Test::Unit::TestCase
  should "return the github url for RedirectFollower('http://bit.ly/cteFsP')" do
    assert_equal 'http://github.com/colszowka/redirect_follower', RedirectFollower('http://bit.ly/cteFsP')
  end
  
  should "return the github url minus the subdomain for RedirectFollower('http://bit.ly/cteFsP')" do
    assert_equal 'http://github.com/colszowka/redirect_follower', RedirectFollower('http://www.github.com/colszowka/redirect_follower')
  end
  
  context "A new RedirectFollower instance initialized with 'http://bit.ly/cteFsP'" do
    setup { @redirect = RedirectFollower.new('http://bit.ly/cteFsP')}
    
    should "return the github url for url" do
      assert_equal 'http://github.com/colszowka/redirect_follower', @redirect.url
    end
    
    should "return some html for body" do
      assert_match /\<div/, @redirect.body
    end
    
    should "have body equal to response.body" do
      assert_equal @redirect.response.body, @redirect.body
    end
    
    should "have response kind of HTTPSuccess" do
      assert @redirect.response.kind_of?(Net::HTTPSuccess)
    end
  end
  
  should "raise RedirectFollower::TooManyRedirects when calling RedirectFollower('http://bit.ly/aRmOtk', 1)" do
    assert_raise(RedirectFollower::TooManyRedirects) { RedirectFollower('http://bit.ly/aRmOtk', 1) }
  end
  
  context "A new RedirectFollower instance initialized with 'http://bit.ly/aRmOtk' and a limit of 1" do
    setup { @redirect = RedirectFollower.new('http://bit.ly/aRmOtk', 1)}
    
    should "raise RedirectFollower::TooManyRedirects when requesting url" do
      assert_raise(RedirectFollower::TooManyRedirects) { @redirect.url }
    end
    
    should "raise RedirectFollower::TooManyRedirects when requesting body" do
      assert_raise(RedirectFollower::TooManyRedirects) { @redirect.body }
    end
    
    should "raise RedirectFollower::TooManyRedirects when requesting response" do
      assert_raise(RedirectFollower::TooManyRedirects) { @redirect.response }
    end
    
    context "after modifiying the limit to 2" do
      setup { @redirect.redirect_limit = 2 }
      
      should "return the github url for url" do
        assert_equal 'http://github.com/colszowka/redirect_follower', @redirect.url
      end
      
      should "return some html for body" do
        assert_match /\<div/, @redirect.body
      end
      
      should "have body equal to response.body" do
        assert_equal @redirect.response.body, @redirect.body
      end
      
      should "have response kind of HTTPSuccess" do
        assert @redirect.response.kind_of?(Net::HTTPSuccess)
      end
    end
  end
  
end
