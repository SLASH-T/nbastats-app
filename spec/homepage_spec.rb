require_relative 'spec_helper'

describe 'Homepage' do
  before do
    unless @browser
      #NBAStats::ApiGateway.new.delete_all_repos
      @browser = Watir::Browser.new
    end
  end

  after do
    @browser.close
  end

  describe 'Empty Homepage' do
    it '(HAPPY) should see no content' do
      # GIVEN: user is on the home page without any projects
      @browser.goto homepage
      @browser.button(id: 'menu-toggle').click

      # THEN: user should see basic headers, no projects and a welcome message
      _(@browser.h1(id: 'main_header').text).must_equal 'NBA'
      _(@browser.h1(id: 'p_header').text).must_equal 'TOP 5 Today'
      _(@browser.text_field(name: 'INPUT_DATETIME').visible?).must_equal true
      _(@browser.text_field(id: 'INPUT_DATETIME').visible?).must_equal true
      _(@browser.table(id: 'game_table').exists?).must_equal true
    end
  end
end
