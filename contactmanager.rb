require 'csv'

class ContactManager 
	
	def initialize(csvfile)
		@contacts = {}
		fields_to_insert = %w{ first_name last_name phone email}
		CSV.foreach(csvfile, headers: true) do |row|
			row_to_insert = row.to_hash.select { |k, v| fields_to_insert.include?(k) }
			@contacts[row_to_insert["email"].downcase] = row_to_insert
		end
	end
	
	def printAll
		@contacts.each do |row|
			digits = formatNumber(row[1]["phone"])
			puts "Last: " << row[1]["last_name"] << ", First:"  << row[1]["first_name"] << ", Phone:" << digits << ", E-Mail:" << row[1]["email"]
		end
	end
	
	def printByMail(email=false)
		result = "Error: email not found"
		if (email)
			email.downcase!
			if (@contacts[email])
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
			placeholder = {}
			@contacts.each do |row|
				if (letter.downcase == row[1]["last_name"][0,1].downcase)
					digits = formatNumber(row[1]["phone"])
					placeholder[row[1]["last_name"]] = "Last: " << row[1]["last_name"] << ", First:"  << row[1]["first_name"] << ", Phone:" << digits << ", E-Mail:" << row[1]["email"]
				end
			end
			placeholder = placeholder.sort
			placeholder.each do |row|
				puts row[1]
			end
		end
	end
	
end


cm = ContactManager.new("data.csv")
while true do
puts "Type \n1 to print all\n2 to search by email\n3 to print by last name's first letter\n4 to print test cases\n5 to quit"
input = gets.chomp
if (input == "1")
	cm.printAll
elsif (input == "2")
	puts "Type the user's email"
	input = gets.chomp
	cm.printByMail(input)
elsif (input == "3") 
	puts "Type the last name's first letter"
	input = gets.chomp
	while (input.length != 1)
		puts "Type only one letter"
		input = gets.chomp
	end
	
		cm.printByLetter(input)

elsif (input == "4")
	puts "Printing all:\n"
	cm.printAll
	puts "\n\nPrinting by email lisaesauceda@armyspy.com"
	cm.printByMail("lisaesauceda@armyspy.com")
	puts "\n\nPrinting by letter s"
	cm.printByLetter('s')

elsif (input == "5")
	break
else
	
		puts "Invalid selection"
end


end
