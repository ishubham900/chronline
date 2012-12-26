###
# Given step definitions
###

Given /^there exists an? (\w+)$/ do |type|
  instance_variable_set("@#{type}", FactoryGirl.create(type))
end

Given /^there exist (\d+) (\w+)$/ do |n, collection|
  models = FactoryGirl.create_list(collection.singularize, n.to_i)
  instance_variable_set("@#{collection}", models)
end

Given /^I am on the (\w+) (\w+) page$/ do |action, collection|
  visit url_for(action: action,
                controller: "admin/#{collection.pluralize}",
                subdomain: :admin,
                port: Capybara.current_session.driver.app_server.port,
                host: 'lvh.me')
end


###
# Then step definitions
###

When /^I fill in "(.*?)" with "(.*?)"$/ do |field, value|
 fill_in field, with: value
end

When /^I leave "(.*?)" empty$/ do |field|
 fill_in field, with: nil
end

When /^I click "(.*?)"$/ do |button|
  begin
    click_button button
  rescue Capybara::ElementNotFound
    click_link button
  end
end


###
# Then step definitions
###

Then /^I should see (\d+) (\w+) listed$/ do |n, collection|
  page.all('tr').should have(n.to_i).rows
end

Then /^the "(.*?)" field should show an error$/ do |field|
  find_field(field).find(:xpath, '../..')[:class].should include('error')
end

Then /^the "(.*?)" field should be set to "(.*?)"$/ do |field, value|
  find_field(field).value.should == value
end

Then /^a new (\w+) should be created$/ do |class_name|
  class_name.constantize.count.should == 1
end

Then /^I should be on the article manage page$/ do
  current_path.should == admin_articles_path
end

Then /^it should have a link to the next page$/ do
  page.should have_link('Next', href: "#{current_path}?page=2")
end

Then /^(\w+) should no longer exist$/ do |model|
  cls = model.camelcase.constantize
  instance = instance_variable_get("@#{model}")
  cls.find_by_id(instance.id).should be_nil
end


###
# Helpers
###

def confirm_alert(type, message)
  find(".alert-#{type.to_s}").should have_content(message)
end
