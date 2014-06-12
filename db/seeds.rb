# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# Default template page

Template.create! :name => 'Default', :html => <<EndOfPage
<!DOCTYPE html>
<html>
  <head>
    <title>MOOCchat Default Template</title>
    <link rel="stylesheet" type="text/css" href="/public/stylesheets/default.css" media="all"/>
  </head>
  <body>
    <div id="main">
      <h1>Default Template</h1>
      <p>This is a MOOCchat default page template.</p>
    </div>
    <div id="footer">
      <p>Page ID: <%= @page_id %> </p>
    </div>
  </body>
</html>

EndOfPage
