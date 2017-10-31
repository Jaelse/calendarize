Feature: Calendarize
This is for users of calendarize.

Scenario: Sign in as Superadmin

A superadmin should be able to login.

Given I am a superadmin
And I want to add a secratary for a department.
Given I am signed in
Then I should see a link for adding a new secratary
When I click the link for adding a new secratary
Then I should see a form to add a secratary
When I submit the form
Then I should see the details of the newly added secratary 
