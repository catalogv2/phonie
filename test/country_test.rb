require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class CountryTest < Phonie::TestCase
  def test_find_by_country_name
    country = Phonie::Country.find_by_name('canada')
    assert_equal "Canada", country.name

    country = Phonie::Country.find_by_name('Canada')
    assert_equal "Canada", country.name

    assert_nil  Phonie::Country.find_by_name(nil)
    assert_nil  Phonie::Country.find_by_country_code(nil)
    assert_equal [],  Phonie::Country.find_all_by_phone_code(nil)
  end

  def test_find_by_country_code
    country = Phonie::Country.find_by_country_code('NO')
    assert_equal "Norway", country.name
  end

  def test_find_all_by_phone_code
    countries = Phonie::Country.find_all_by_phone_code('47')
    assert_equal 1, countries.length
    assert_equal "Norway", countries.first.name
  end

  def test_national_dialing_prefix
    tonga = Phonie::Country.find_by_country_code('TO')
    assert_nil tonga.national_dialing_prefix

    us_and_a = Phonie::Country.find_by_country_code('US')
    assert_equal '1', us_and_a.national_dialing_prefix
  end

  def test_strict_validation
    assert Phonie.configuration.strict_validation
    assert_nil Phonie::Country.find_by_country_code('ID')

    Phonie.configure do |config|
      config.strict_validation = false
    end
    Phonie::Country.reload
    assert indonesia = Phonie::Country.find_by_country_code('ID')
    assert_equal '\d+', indonesia.parser.area_code

    assert indonesia.is_valid_number?('+628342024961')
    assert indonesia.possible_valid_number?('08342024961')
  end
end
