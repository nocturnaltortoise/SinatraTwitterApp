require 'uri'
require 'cgi'
require 'selenium-webdriver'
require_relative '../support/paths'

module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)

Given /^(?:|I )am on (.+)$/ do |page_name|
   visit path_to(page_name)
end

@randomString = "unspecified"

When /^(?:|I )fill in "([^\"]*)" with a random string(?: within "([^\"]*)")?$/ do |field, selector|
  @randomString = rand(36**15).to_s(36)
  with_scope(selector) do
    fill_in(field, :with => @randomString)
  end
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press the delete button for the random string(?: within "([^\"]*)")?$/ do |selector|
  with_scope(selector) do
    click_link("Delete", href: "?delete=#{@randomString}")
  end
end

When /^(?:|I )press the delete button for "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, selector|
  with_scope(selector) do
    click_link("Delete", href: "?delete=#{text}")
  end
end

When /^(?:|I )press the unfollow button for "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, selector|
  with_scope(selector) do
    click_link("Unfollow", href: "/following?run=true&unfollow=#{text}")
  end
end

When /^(?:|I )press the follow button for "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, selector|
  with_scope(selector) do
    click_link("Follow", href: "/previously_followed?run=true&follow=#{text}")
  end
end

When /^(?:|I )press the edit button for the random string(?: within "([^\"]*)")?$/ do |selector|
  with_scope(selector) do
    click_link("Edit", href: "?edit_term=#{@randomString}")
  end
end

When /^(?:|I )press the edit hashtag button for the random string(?: within "([^\"]*)")?$/ do |selector|
  with_scope(selector) do
    click_link("Edit", href: "?edit_hashtag=#{@randomString}")
  end
end

When /^(?:|I )press the Follow button(?: within "([^\"]*)")?$/ do |selector|
  with_scope(selector) do
    click_link("Follow!", href: "/automatic_following?run=true")
  end
end

When /^(?:|I )press "([^\"]*)"(?: within "([^\"]*)")?$/ do |button, selector|
  with_scope(selector) do
    click_button(button)
  end
end

When /^(?:|I )follow "([^\"]*)"(?: within "([^\"]*)")?$/ do |link, selector|
  with_scope(selector) do
    click_link(link)
  end
end

When /^(?:|I )fill in "([^\"]*)" with "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, value, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end

When /^(?:|I )fill in "([^\"]*)" for "([^\"]*)"(?: within "([^\"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^(?:|I )fill in the following(?: within "([^\"]*)")?:$/ do |selector, fields|
  with_scope(selector) do
    fields.rows_hash.each do |name, value|
      When %{I fill in "#{name}" with "#{value}"}
    end
  end
end

When /^(?:|I )select "([^\"]*)" from "([^\"]*)"(?: within "([^\"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    select(value, :from => field)
  end
end

When /^(?:|I )check "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    check(field)
  end
end

When /^(?:|I )uncheck "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    uncheck(field)
  end
end

When /^(?:|I )choose "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    choose(field)
  end
end

When /^(?:|I )attach the file "([^\"]*)" to "([^\"]*)"(?: within "([^\"]*)")?$/ do |path, field, selector|
  with_scope(selector) do
    attach_file(field, path)
  end
end

Then /^(?:|I )should see JSON:$/ do |expected_json|
  require 'json'
  expected = JSON.pretty_generate(JSON.parse(expected_json))
  actual   = JSON.pretty_generate(JSON.parse(response.body))
  expected.should == actual
end

Then /^(?:|I )should see "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_content(text)
    else
      assert page.has_content?(text)
    end
  end
end

Then /^(?:|I )should see a "([^\"]*)" selector(?: within "([^\"]*)")?$/ do |selector1, selector2|
  with_scope(selector2) do
    if page.respond_to? :should
      page.should have_selector(selector1)
    else
      assert page.has_selector?(selector1)
    end
  end
end

Then /^(?:|I )should see the random string(?: within "([^\"]*)")?$/ do |selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_content(@randomString)
    else
      assert page.has_content?(@randomString)
    end
  end
end

Then /^(?:|I )should see a disabled "([^\"]*)" button(?: within "([^\"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_button(text, :disabled => true)
    else
      assert page.has_button?(text, :disabled => true)
    end
  end
end

Then /^(?:|I )should see "([^\"]*)" within a "([^\"]*)" field(?: within "([^\"]*)")?$/ do |text, field, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_field(field, type: "text", with: text)
    else
      assert page.has_field?(field, type: "text", with: text)
    end
  end
end

Then /^(?:|I )should see the random string within a "([^\"]*)" field(?: within "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_field(field, type: "text", with: @randomString)
    else
      assert page.has_field?(field, type: "text", with: @randomString)
    end
  end
end

Then /^(?:|I )should not see the random string within a "([^\"]*)" field(?: within "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should_not (have_field(field, type: "text", with: @randomString))
    else
      assert page.has_no_field?(field, type: "text", with: @randomString)
    end
  end
end

Then /^(?:|I )should see \/([^\/]*)\/(?: within "([^\"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_xpath('//*', :text => regexp)
    else
      assert page.has_xpath?('//*', :text => regexp)
    end
  end
end

Then /^(?:|I )should not see "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_no_content(text)
    else
      assert page.has_no_content?(text)
    end
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/(?: within "([^\"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_no_xpath('//*', :text => regexp)
    else
      assert page.has_no_xpath?('//*', :text => regexp)
    end
  end
end

Then /^the "([^\"]*)" field(?: within "([^\"]*)")? should contain "([^\"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then /^(?:|I )should see a "([^\"]*)" image(?: within "([^\"]*)")?$/ do |id, selector|
  with_scope(selector) do
    image = find_by_id(id)
    if page.respond_to? :should
      image.visible?
    end
  end
end

Then /^the "([^\"]*)" field(?: within "([^\"]*)")? should not contain "([^\"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^\"]*)" checkbox(?: within "([^\"]*)")? should be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should == 'checked'
    else
      assert_equal 'checked', field_checked
    end
  end
end

Then /^the "([^\"]*)" checkbox(?: within "([^\"]*)")? should not be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should_not
      field_checked.should_not == 'checked'
    else
      assert_not_equal 'checked', field_checked
    end
  end
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair{|k,v| expected_params[k] = v.split(',')}

  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

Then /^show me the page$/ do
  save_and_open_page
end
