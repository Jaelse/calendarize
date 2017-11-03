Feature: Calendarize
This is for users of calendarize.

Scenario: Sign in as Superadmin

A superadmin should be able to login.

Given I am a superadmin
And I am signed in

Scenario: secretary can add students of their department

Given I am a secretary
And I am signed in
Then I can add a student of my department
