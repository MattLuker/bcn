---
title: "Writing CSV Data to Google Sheets"
layout: post
date:   2015-07-07 14:30:00
categories: ruby learning
image: sheet_edit_cover.jpg
---

# Writing CSV Data to Google Sheets


I love Google Sheets mostly because it's not Excel.  Not that I've had a lot to do with Excel in the past, but every time I've had to deal with it there are always compatibility issues.  It's the worst when there are issues with he same data between different versions of Excel... garr.

There might be similar issues with the different versions of Google Sheets that have been released through the years, but if there are I haven't used it enough to run into them.  It could also be that people who use Google Sheets don't use the more complicated features of Excel and don't have as many problems.

Either way Google Sheets is tops in my book.
<!--more-->

## Getting Things Setup for Authentication

To kick things off install the [google-drive-ruby](https://github.com/gimite/google-drive-ruby) gem:

```
gem install  google_drive
```

**Note:** depending on your Ruby environment you may have to slap a **sudo** onto the beginning of the gem install command.

> There is an official  gem [google-api-client](https://github.com/google/google-api-ruby-client), but I couldn't find an example for writing to Google Sheets, so I'm not sure that particular API is included at this time.  So we'll go with the lovely community developed gem *google-drive-ruby*.

With the local Ruby setup create the OAuth client ID and secret by going to the [Google Developers Console](https://console.developers.google.com/) and following the [directions here](https://developers.google.com/drive/web/auth/web-server) and enable the Drive API.

## Getting Authenticated (Feels so Good)

Time to whip up some Ruby code to get the OAuth access token from Google.  Create a Ruby named **write_sheets.rb** file with:

```
require "google/api_client"
require "google_drive"

# Authorizes with OAuth and gets an access token.
client = Google::APIClient.new
auth = client.authorization
auth.client_id = "YOUR CLIENT ID"
auth.client_secret = "YOUR CLIENT SECRET"
auth.scope = [
  "https://www.googleapis.com/auth/drive",
  "https://spreadsheets.google.com/feeds/"
]
auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
print("2. Enter the authorization code shown in the page: ")
auth.code = $stdin.gets.chomp
auth.fetch_access_token!
access_token = auth.access_token

# Creates a session.
session = GoogleDrive.login_with_oauth(access_token)

# Gets list of remote files.
session.files.each do |file|
  p file.title
end
```

Run the script then copy and paste the URL from the output into a browser:

```
ruby write_sheets.rb
```

You will be taken to a Google page with a prompt to accept, or deny, the permissions for the application.  I choose accept since I would  like to access my Google Drive with this app.  

Then copy and paste the code into your terminal window:

```
W, [2015-07-07T06:57:49.711210 #17360]  WARN -- : Google::APIClient - Please provide :application_name and :application_version when initializing the client
1. Open this page:
https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=892946759984-nu7f8mg6vk13gqjundtsmsrmck7jm2ud.apps.googleusercontent.com&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&scope=https://www.googleapis.com/auth/drive%20https://spreadsheets.google.com/feeds/
```

The script should then output a list of files in your Google Drive.

## Practice Writing

In order to write to a Google Sheet you need the document ID for a particular sheet.  You can find the ID in the URL.  Open the Sheet you want to write to in a browser, and copy the portion after the ```https://docs.google.com/spreadsheets/d/``` and before the ```/edit#gid=0``` at the end.

![](../img/sheet_id.png)

So we can authenticate and get data from Google so let's do some writing.  Adjust the script like so replacing the bottom portion below the **session** variable setup:

```
# First worksheet of Sheet.
ws = session.spreadsheet_by_key("YOUR_SHEET_ID").worksheets[0]

# Gets content of A2 cell.
p ws[2, 1]  #==> "hoge"

# Changes content of cells.
# Changes are not sent to the server until you call ws.save().
ws[2, 1] = "foo"
ws[2, 2] = "bar"
ws.save

# Dumps all cells.
(1..ws.num_rows).each do |row|
  (1..ws.num_cols).each do |col|
    p ws[row, col]
  end
end

# Yet another way to do so.
p ws.rows  #==> [["fuga", ""], ["foo", "bar]]

# Reloads the worksheet to get changes by other clients.
ws.reload
```

Don't forget to copy the Sheet ID.  Run the script and copy and paste the OAuth code as before:

```
W, [2015-07-07T07:11:54.618716 #17523]  WARN -- : Google::APIClient - Please provide :application_name and :application_version when initializing the client
1. Open this page:
https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=892946759984-nu7f8mg6vk13gqjundtsmsrmck7jm2ud.apps.googleusercontent.com&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&scope=https://www.googleapis.com/auth/drive%20https://spreadsheets.google.com/feeds/

2. Enter the authorization code shown in the page: 4/qnADMULuAojg5_osfqwKTfAkDliZaPS0hRzLruFwjGs
"foo"
""
""
"foo"
"bar"
[["", ""], ["foo", "bar"]]
```

Your output should be similar, and when you open the document in Google Drive you should see *foo* in cell A2 and *bar* in cell B2.

## Writing CSV Data


In last week's Ruby post we grabbed some data from the web and blasted it into some CSV files.  Let's use the data from one of those files and write it to our Google Sheet.

Create a new Ruby script named **bears_sheet_write.rb** (or whatever you'd like, I'm not the boss of you).

The first task is to open the CSV file and read it's contents.  I'm going to use the **output_files/Defense.csv** file since it's the largest:

```
#
# Use the google-drive-ruby library to write to Google Sheets.
#

require "google/api_client"
require "google_drive"
require 'csv'

# Authorizes with OAuth and gets an access token.
client = Google::APIClient.new
auth = client.authorization
auth.client_id = '892946759984-nu7f8mg6vk13gqjundtsmsrmck7jm2ud.apps.googleusercontent.com'
auth.client_secret = '4dDuv8Ev80PlMjiaqVOEPUaE'
auth.scope = [
    "https://www.googleapis.com/auth/drive",
    "https://spreadsheets.google.com/feeds/"
]

auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
print("2. Enter the authorization code shown in the page: ")

auth.code = $stdin.gets.chomp
auth.fetch_access_token!
access_token = auth.access_token

# Creates a session.
session = GoogleDrive.login_with_oauth(access_token)

# First worksheet of
ws = session.spreadsheet_by_key("18rL3S0zTGFWTmOjeusM_2vQVW40dZMrAnKeQYiWIFfA").worksheets[0]

# Open the CSV file read it's contents and loop over the rows.
CSV.foreach('output_files/Defense.csv') do |row|
  puts row.inspect
  row.each_with_index do |cell, idx|
    # Need to start at cell 1,1 to add 1 to the row idx.
    ws[$., idx + 1] = cell
  end
end

ws.save

p ws.rows
ws.reload
```

Compare this to the previous write test and you'll see they are the same (except for the ```require 'cvs'``` line) until the actual writing part.  Here we open the CSV file, read the contents and loop through each line (row), then to another loop over each column (cell), and write the contents to the appropriate cell in the Sheet.

At the end we save the Sheet and dump the whole thing, but the dumping isn't strictly necessary.

## Conclusion

It is a little confusing to use the Google APIs at first.  There are a lot of libraries and guides out there, not to mention the different API versions, and sometimes you can get lost in the documentation.  The **google-drive-ruby** gem is great, but manually opening the link and pasting in the access_token each time you run the script is a pain in the left eye ball.

I might write up a follow-up post on how to accomplish that part in one fell swoop.

Party on!
