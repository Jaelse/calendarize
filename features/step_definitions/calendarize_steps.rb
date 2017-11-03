Given("I am a superadmin") do
  @superadmin = FactoryGirl.create :superadmin
end

Given("I am signed in") do
  visit '/sessions/new?user=superadmin'
  fill_in 'Username', with: @superadmin.suadusername
  fill_in 'Password', with: @superadmin.suadpassword
  click_button 'Log in'
end


Given("I am a secretary") do
  @secretary = FactoryGirl.create :secretary
end

Then("I can add a student of my department") do
  visit
end
