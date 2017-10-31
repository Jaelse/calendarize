Given("I am a superadmin") do
  @superadmin = FactoryGirl.create :superadmin
end

Given("I want to add a secratary for a department.") do
  #@user = FactoryGirl.create :user
  #@secretary = FactoryGirl.create :secretary
end

Given("I am signed in") do
  visit '/sessions/new?user=superadmin'
  fill_in 'Username', with: @superadmin.suadusername
  fill_in 'Password', with: @superadmin.suadpassword
  click_button 'Log in'
end

Then("I should see a link for adding a new secratary") do

end

When("I click the link for adding a new secratary") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should see a form to add a secratary") do
  pending # Write code here that turns the phrase above into concrete actions
end

When("I submit the form") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should see the details of the newly added secratary") do
  pending # Write code here that turns the phrase above into concrete actions
end
