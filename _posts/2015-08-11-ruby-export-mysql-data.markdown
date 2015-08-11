---
title: "Export MySQL Data to CSV"
date:   2015-08-11 14:30:00
layout: post
categories: ruby learning
image: database_cover.svg
---

## Migrating Isn’t Just For Birds… Maybe?

Nothing lasts forever and sometimes you have to move data from one system to another.  In this example we’re going to export a list of users from a MySQL table and save them into a file, a CSV file to be exact.

The CSV format is great for this task cause basically it’s already a table.  You just need to blast the data out, copy the file to another server/workstation/what have you, and then blast the data back in.

Granted you could also use a more specific tool like **mysqldump** if you were keeping the same table format.  In the case where you’re starting over with a new table schema it’s usually easier to write a script to export and another one to import the data.  

At least that’s been my experience.

<!--more-->

## First Things First, Install Some Gems

Whip open a terminal and enter:

```
 gem install mysql2
```

The [mysql2](https://github.com/brianmario/mysql2) gem is needed to connect to the database and run queries.  

## The Scripty Script

This script is very similar to the other CSV scripts we’ve been working with.  We first get some data, from a database this time, loop through it, then write it to a file.

{% highlight ruby %}
#
# Export users using Ruby.
#

require 'mysql'
require 'csv'

mysql = Mysql.init()
mysql.connect(host='database_server_hostname', user='databse_username', passwd='database_password', db='database_name')


CSV.open("users.csv", "wb") do |csv|
  csv << ["email","username","display_name"]
  mysql.query("select email, username, display_name from users;").each { |row| csv << row }
end
{% endhighlight %}

Be sure to change the following to match your database environment:

* database_server_hostname
* database_username
* database_password
* database_name

These values will be specific to your MySQL server.

As you can see the script initializes a connection to the server using the connection string.  Then the CSV file is opened for *writing* and the header row is written.  Next, the query is executed and each row’s fields are written.  

## Conclusion

As you can see this example uses a table that contains user data, but you can customize it to export any table.  Actually you can customize it to export the data from any query.  So if you need data from multiple tables you can use a more complicated query then write the data to CSV.

Party On!
