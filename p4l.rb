
require 'csv'
require 'json'
require 'nokogiri'

class DataParser

  #  read csv file and load data into array and reformat
  def readCsvIntoString(hashed_data1, path, dataFolder)
    data = CSV.read(path+"\\#{dataFolder}\\users.csv", { encoding: "UTF-8", headers: true, converters: :all})
    hashed_data1 = data.map { |d| d.to_hash }
    return hashed_data1
  end

  #read json file and load data into array and reformat
  def readJsonIntoString(hashed_data2, path, dataFolder)
    user2 = File.read(path+"\\#{dataFolder}\\users.json")
    hashed_data2 = JSON.parse(user2)
    return hashed_data2
  end

  #read xml file and load data into array and reformat
  def readXmlIntoString(hashed_data3, path, dataFolder)
    str = File.open(path+"\\#{dataFolder}\\users.xml") #{ |f| Nokogiri::XML(f) }
    doc = Nokogiri.XML(str)
    doc.xpath('//user').each do |zone|
      hashed_data3 << { "userid" => zone.xpath('userid').text, "firstname" => zone.xpath('firstname').text, "lastname" => zone.xpath("surname").text, "username" => zone.xpath("username").text, "type" => zone.xpath("type").text, "lastlogin_time" => zone.xpath("lastlogintime").text}
    end
    return hashed_data3
  end

  #method to get the keys
  def getKeys(data_keys)
    data_keys[0].keys
  end

  #method to arrange the data 
  def getStringValues(hashed_data1, hashed_data2, hashed_data3)
    newDataValues = []
    d3 = hashed_data3.length-1
    d2 = hashed_data2.length-1
    d1 = hashed_data1.length-1
    for i in (0..d3) do 
      newDataValues << hashed_data3[i].values
    end
    for i in (0..d2) do 
      newDataValues << hashed_data2[i].values
    end
    for i in (0..d1) do 
      newDataValues << hashed_data1[i].values
    end 
    return newDataValues
  end

  #method to sort the data
  def sortDataByUserId(hashed_data1)
    newDataValues = []
    sorted_hashed_data1 = []
    d1 = hashed_data1.length-1
    sorted_hashed_data1 = hashed_data1.sort_by { |k| k["User ID"] }
    for i in (0..d1) do 
      newDataValues << sorted_hashed_data1[i].values
    end
    return newDataValues
  end

  #method to get new data values
  def getNewDataValues(newDataValues, ndv, convert)
    if convert == true  
      for u in (0..ndv) do #|u|
        newDataValues[u][0] = newDataValues[u][0].to_s
        newDataValues[u][5] = DateTime.strptime(newDataValues[u][5], '%d-%m-%Y %H:%M:%S')
        newDataValues[u][5] = newDataValues[u][5].to_s
      end
      return newDataValues
    else 
      return newDataValues
    end
  end

  #method to write csv file
  def writeCsvFile(ndv, p4l, csvkeys, new_datavalues, path, outputFolder)
    (0..ndv).each do |j|
      p4l[j] = csvkeys.zip(new_datavalues[j])
    end
    column_names = csvkeys
    csvfile = CSV.generate do |csv|
      csv << column_names
      new_datavalues.each do |elem|
        csv << elem
      end
    end
    File.write(path+"\\#{outputFolder}\\users.csv", csvfile)
    new_datavalues = []
  end
  
  #method to write json file
  def buildJsonFile(ndv, p4l, jsonkeys, new_datavalues, path, outputFolder)
    (0..ndv).each do |j|
      p4l[j] = jsonkeys.zip(new_datavalues[j])
    end
    File.open(path+"\\#{outputFolder}\\users.json","w") do |json|
      json.write(p4l.to_json)
    end
    new_datavalues = []
  end

  #method to build xml file
  def buildXML(label,array,xml)
    array.each do |hash|
      xml.send(label) do
        # Create an element named for the label
        hash.each do |key,value|
          if value.is_a?(Array)
            buildXML(key,value,xml)
          else
            # Create <key>value</key> (using variables)
            xml.send(key,value)
          end
        end
      end
    end
  end

  #method to write xml file
  def buildXmlFile(ndv, p4l, xmlkeys, new_datavalues, xmlp4l, path, outputFolder)
    (0..ndv).each do |j|
      p4l[j] = xmlkeys.zip(new_datavalues[j])
      xmlp4l << Hash[p4l[j]]
    end
    
    newp4l = Nokogiri::XML::Builder.new do |xml|
      xml.users{ buildXML('user', xmlp4l,xml) }
    end
    #write array to new xml file
    File.open(path+"\\#{outputFolder}\\users.xml","w") do |xml|
      xml.write(newp4l.to_xml)
    end
    new_datavalues = []
  end
end


class WriteToTempDataFolder < DataParser
  def writeToTempDataFolder()
    p4l            = []
    csvp4l         = []
    jsonp4l        = []
    xmlp4l         = []
    xp4l           = []
    hashed_data1   = []
    hashed_data2   = []
    hashed_data3   = []
    xmlp4l         = []
    convert        = true
    ndv            = 0
    path           = "C:\\p4l"
    dataFolder     = "data"
    hashed_data1   = readCsvIntoString(hashed_data1, path, dataFolder)
    hashed_data2   = readJsonIntoString(hashed_data2, path, dataFolder)
    hashed_data3   = readXmlIntoString(hashed_data3, path, dataFolder)
    csvkeys        = getKeys(hashed_data1)
    jsonkeys       = getKeys(hashed_data2)
    xmlkeys        = getKeys(hashed_data3)
    newDataValues  = getStringValues(hashed_data1, hashed_data2, hashed_data3)#, new_datavalues)
    ndv            = newDataValues.length-1
    new_datavalues = getNewDataValues(newDataValues, ndv, convert)
    outputFolder   = "tempdata"
    writeCsvFile(ndv, p4l, csvkeys, new_datavalues, path, outputFolder)
    buildJsonFile(ndv, p4l, jsonkeys, new_datavalues, path, outputFolder)
    buildXmlFile(ndv, p4l, xmlkeys, new_datavalues, xmlp4l, path, outputFolder)
  end
end


class WrteToOutputFolder < DataParser
  def wrteToOutputFolder()
    p4l            = []
    csvp4l         = []
    jsonp4l        = []
    xmlp4l         = []
    xp4l           = []
    hashed_data1   = []
    xmlp4l         = []
    ndv            = 0
    path           = "C:\\p4l"
    convert        = false
    dataFolder     = "tempdata"
    hashed_data1   = readCsvIntoString(hashed_data1, path, dataFolder)
    csvkeys        = getKeys(hashed_data1)
    jsonkeys       = getKeys(hashed_data1)
    xmlkeys        = getKeys(hashed_data1)
    newDataValues  = sortDataByUserId(hashed_data1)
    ndv            = newDataValues.length-1
    newDataValues  = getNewDataValues(newDataValues, ndv, convert)
    outputFolder   = "output"
    writeCsvFile(ndv, p4l, csvkeys, newDataValues, path, outputFolder)
    buildJsonFile(ndv, p4l, jsonkeys, newDataValues, path, outputFolder)
    buildXmlFile(ndv, p4l, xmlkeys, newDataValues, xmlp4l, path, outputFolder)
  end
end

 
class PrintOutputData < DataParser
  attr_accessor :filePath, :prints

  def initialize(filePath, prints)
    @filePath = filePath
    @prints   = prints
  end

  def printOutputData()
    hashed_data1      = []
    hashed_data2      = []
    hashed_data3      = []
    path              = "C:\\p4l"
    dataFolder        = @filePath
    filesToPrint      = @prints
    if filesToPrint == "all"
      puts "-------------------------------------------------------------------------------------------------------"
      puts hashed_data1 = readCsvIntoString(hashed_data1, path, dataFolder)
      puts hashed_data2 = readJsonIntoString(hashed_data2, path, dataFolder)
      puts hashed_data3 = readXmlIntoString(hashed_data3, path, dataFolder)
      puts "-------------------------------------------------------------------------------------------------------"
    elsif filesToPrint == "1"
      puts "-------------------------------------------------------------------------------------------------------"
      puts hashed_data1 = readCsvIntoString(hashed_data1, path, dataFolder)
      puts "-------------------------------------------------------------------------------------------------------"
    end
  end
end



# Uncomment the code below to run with "C:\ruby p4l.rb"
# printData = PrintOutputData.new("data", "all")
# printData.printOutputData
# createData = WriteToTempDataFolder.new
# createData.writeToTempDataFolder
# createFile = WrteToOutputFolder.new
# createFile.wrteToOutputFolder
# printData = PrintOutputData.new("output", "1")
# printData.printOutputData
