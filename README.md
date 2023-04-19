# Little Esty Shop
### Name of Contributors & Github Links

[Alejandro Lopez](https://github.com/AlejandroLopez1992)<br>
[Julian Beldotti](https://github.com/JCBeldo)<br>
[Reid Miller](https://github.com/reidsmiller)<br>
[Stephen McPhee](https://github.com/SMcPhee19)<br>

### Descirption of Project
This project, entitled "Little Esty Shop", is a Turing BE-Mod2 Group Project focusing on designing an e-commerce platform. It's funcitonality would allow merchants as well as admins to manage inventory & fulfill customers orders. 

The project was completed using `Ruby on Rails` and `PostgreSQL` for the database, `Render` for app deployment to the web, and `Github Projects` for time and project management. 

New concepts learned during the course of this project included: 
- implementing `rake tasks` in order to seed data from the `CSV` files into the database; 
- working with new gems for additional functionality including `factory_bot_rails`, `faker` and `HTTParty`
- creating complex `ActiveRecord` queries to the database; 
- Consumed an external `API` to serve data to our site.

Goals achieved during this project:
- 100% coverage of Model and Feature tests using simplecov
- Worked with and extracted information from multiple objects using `ActiveRecord` queries.
- 100% completion of all the user stories
- Collaborated togeher as a group and then in pairs to successfully complete the project.
- Used GitHub projects, milestones, and issues to effectively coordinate all tasks amongst the team.

Summary of Milestones:
- Merchant Dashboard - This page shows details for a particular merchant, including the items that are ready to ship and favorite customers
- Merchant Invoices - This displays an index page for invoices that links to a show page which shows information for the customer on this invoice and a table that shows each item on the invoice including a selector which allows for the user update the status
- Merchant Items - These pages allow a visitor to enable/disable particular items and click into those items to see a description. Additionally it reflects the sales of the top five items that this merchant has sold alongside their sales amount and best date of purchases
- Admin Dashboard - Shows top 5 customers by successful transactions and all incomplete invoices
- Admin Merchants - Merchant index and show pages, with top 5 merchants by revenue, disabled and enabled merchants, and edit merchants functionality
- Admin Invoices - Shows an index page of all IDs in the system and then Shows the details of each individual invoice. Detailed customer, invoice, and item information
- Unsplash API consumption - Adds images to various show pages and a logo to all pages

Potential Refactor Opportunities
- Make two partials to display easy access links for a user and admin to navigate between dashboard, items, and invoice pages.
- Create a welcome page.
- Style the whole app with CSS.
- Within methods that calculate total revenue implement a subquery that insures only one successful transaction is taken into account per invoice.
- Add number_to_currency to the view page to nicely format the prices and total revenue.