# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Create initial categories
categories = Category.create([
                             {name: 'Automotive'},
                             {name: 'Music and Art'},
                             {name: 'Entertainment'},
                             {name: 'Nightlife'},
                             {name: 'Grocery'},
                             {name: 'IT/Technology'},
                             {name: 'Legal'},
                             {name: 'Real Estate'},
                             {name: 'Landscaping'},
                             {name: 'Business'},
                             {name: 'Accounting'},
                             {name: 'Food and Dining'},
                             {name: 'Architecture'},
                             {name: 'Woodworking'},
                             {name: 'General Repair/Handyman Work'},
                             {name: 'Plumbing'},
                             {name: 'Business'},
                             {name: 'Medical'},
                             {name: 'Health and Fitness'},
                             {name: 'Grooming and Beauty'},
                             {name: 'Cosmetics and Fashion'},
                             {name: 'Education'},
                             {name: 'HVAC'},
                             {name: 'Electronics'},
                             {name: 'Gaming'},
                             {name: 'Recreation'},
                             {name: 'Tourism and Travel'},
                             {name: 'Sports/Athletics'},
                             {name: 'Martial Arts'},
                             {name: 'Janitorial and Housekeeping'},
                             {name: 'Fashion and Modeling'},
                             {name: 'Television and Film'},
                             {name: 'Photography'},
                             {name: 'Journalism'},
                             {name: 'Writing'},
                             {name: 'Language and Translation'},
                             ])