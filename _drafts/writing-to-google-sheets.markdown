# Writing CSV Data to Google Sheets

I love Google Sheets mostly because it's not Excel.  Not that I've had a lot to do with Excel in the past, but every time I've had to deal with it there are always compatibility issues.  It's the worst when there are issues with he same data between different versions of Excel... garr.

There might be similar issues with the different versions of Google Sheets that have been released through the years, but if there are I haven't used it enough to run into them.  It could also be that people who use Google Sheets don't use the more complicated features of Excel and don't have as many problems.

Either way Google Sheets is tops in my book.

## Getting Things Setup for Authentication

To kick things off install the [google-api-ruby](https://github.com/google/google-api-ruby-client-samples) gem:

```
gem install  google-api-client
```

**Note:** depending on your Ruby environment you may have to slap a **sudo** onto the beginning of the gem install command.

With the local Ruby setup create the OAuth client ID and secret by going to the [Google Developers Console](https://console.developers.google.com/) and following the [directions here](https://developers.google.com/drive/web/auth/web-server) and enable the Drive API.

After you've created a new client ID download the credentials file and save it as a **client_secret.json**, then move it into the directory where you want to run your script (or download it there directly).

## Getting Authenticated (Feels so Good)

Time to whip up some Ruby code to get the OAuth access token from Google.  Create a Ruby file with:

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
```