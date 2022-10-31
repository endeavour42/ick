#  Ick app test

A simple iOS application demonstrating the following:

The app should define and run 3 requests SIMULTANEOUSLY, each request is defined below:

- Grab url content from the web
 Find the 5th character and display it on the screen 

- Grab url content from the web
- Find every 10th character (i.e. 10th, 20th, 30th, etc.) and display the array on the screen

- Grab url content from the web
Split the text into words using whitespace characters (i.e. space, tab, line break, etc.), count the occurrence of every word (case insensitive) and display the output on the screen
Disregard any HTML/JavaScript. Consider the content as plain text and treat anything separated by whitespace characters as a single word.

Current features & limitations:

- Networking strategy: URLSession's async methods

- UTF8 encoding is assumed in this test. The given URL resource has this encoding but it could be different, we can use "Content-Type" HTTP header field to get actual encoding.

- The whole resource is loaded in the first test, ideally we should load the beginning of the file to get 5th character. Note, in general case it is not known upfront how many bytes to skip to get 5th character (think of multibyte emojis and combining characters).

- View shows a few lines on the first page and up to 10000 characters on the detail page. Perhaps a better UI element would be List, rather than text.

- localization is not included in this test
