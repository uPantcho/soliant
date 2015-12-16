require 'csv'

class ContactManager
	
	def initialize(csvfile)
		@contacts = {}
		fields_to_insert = %w{ first_name last_name phone email} #fields that will be preserved
		CSV.foreach(csvfile, headers: true) do |row|
			row_to_insert = row.to_hash.select { |k, v| fields_to_insert.include?(k) } #remove unwanted fields
			@contacts[row_to_insert["email"]] = row_to_insert #saves in hash by email to get O(1) access
		end
	end
	
	def printAll
		@contacts.each do |row|
			digits = formatNumber(row[1]["phone"]) #formst a 10 digit phone number
			puts "Last: " << row[1]["last_name"] << ", First:"  << row[1]["first_name"] << ", Phone:" << digits << ", E-Mail:" << row[1]["email"]
		end
	end
	
	def printByMail(email=false)
		if (email) 
			if (@contacts[email]) #O(1) access
				digits = formatNumber(@contacts[email]["phone"])
				puts "Last: " << @contacts[email]["last_name"] << ", First:"  << @contacts[email]["first_name"] << ", Phone:" << digits << ", E-Mail:" << @contacts[email]["email"]
			end
		end
		
	end
	
	def formatNumber(digits = 123)
		if (digits.length == 10) 
			digits = "(" << digits[0,3] << ")" << digits[3,3] << "-" << digits[6,4]
		end
	end
	
	def printByLetter(letter = '0')
		if (letter != '0')
			placeholder = {} #this will hold a copy of the entries using last name as hash
			@contacts.each do |row|
				if (letter.downcase == row[1]["last_name"][0,1].downcase) #if matches, add to placebolder
					digits = formatNumber(row[1]["phone"])
					placeholder[row[1]["last_name"]] = "Last: " << row[1]["last_name"] << ", First:"  << row[1]["first_name"] << ", Phone:" << digits << ", E-Mail:" << row[1]["email"]
				end
			end
			placeholder = placeholder.sort #sort by last name 
			placeholder.each do |row|
				puts row[1]
			end
		end
	end
	
end


cm = ContactManager.new("data.csv")
cm.printAll
cm.printByMail("LisaESauceda@armyspy.com")
cm.printByLetter('s')
