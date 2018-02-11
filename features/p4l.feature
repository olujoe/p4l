@p4l_tech_test
Feature: I want to Merge all the users from different files with user ID in ascending order

Scenario: Merge all the users from csv, json and an xml file and sort with user ID in ascending order
	Given I have a data folder with users.csv, users.json and users.xml
	And I empty the output folder, removing any existing files
	When I run the instruction to merge data files
	Then I should see the output folder populated with users.csv, users.json and users.xml
	And I can verify that the data is sorted by user ID in ascending order