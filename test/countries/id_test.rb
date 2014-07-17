require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

## Indonesia (non-strict matching only)
class IDTest < Phonie::TestCase
  def setup
    Phonie.configure do |config|
      config.strict_validation = false
    end
  end

  def test_country_is_loaded
    assert Phonie::Country.find_all_by_phone_code('62')
  end

  def test_local
    assert Phonie::Phone.parse('0 12345', :country_code => '62')
  end

  def test_international
    assert Phonie::Phone.parse('62 12345 6789')
  end

end
