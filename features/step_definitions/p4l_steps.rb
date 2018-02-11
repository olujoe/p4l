
require_relative "../../p4l"

#check that users.csv, users.json and users.xml files exist
Given(/^I have a data folder with users.csv, users.json and users.xml$/) do
	puts Dir["C:/p4l/data/*"]
	printData = PrintOutputData.new("data", "all")
	printData.printOutputData
	puts "----------------------------------- unsorted data from data folder -----------------------------------"
end

#check tempdata and output folder is empty, if not empty delete all file in tempdata and output folders
And(/^I empty the output folder, removing any existing files$/) do
	FileUtils.rm_rf(Dir.glob('C:/p4l/tempdata/*'))
	FileUtils.rm_rf(Dir.glob('C:/p4l/output/*'))
	puts Dir["C:/p4l/tempdata/*"]
	puts Dir["C:/p4l/output/*"]
	puts "----------------------------------- empty output folder -------------------------------------------------"
end

#run the merge and sort commands
When(/^I run the instruction to merge data files$/) do
	createData = WriteToTempDataFolder.new
	createData.writeToTempDataFolder
	createFile = WrteToOutputFolder.new
	createFile.wrteToOutputFolder
	puts "----------------------------------- start file merg and sorting process ---------------------------------"
end

#check that output folder is populated with users.csv, users.json and users.xml
Then(/^I should see the output folder populated with users.csv, users.json and users.xml$/) do
	puts Dir["C:/p4l/output/*"]
	puts "----------------------------------- output folder with data files ---------------------------------------"
end

#print to screen the users.csv, users.json and users.xml files
And(/^I can verify that the data is sorted by user ID in ascending order$/) do
	printData = PrintOutputData.new("output", "1")
	printData.printOutputData
	puts "----------------------------------- output folder data file printout -------------------------------------"
end