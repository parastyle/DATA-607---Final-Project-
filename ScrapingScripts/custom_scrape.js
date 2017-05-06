var url ='http://www.calvinklein.us/en/mens-trunks';
var fs = require('fs');
var path = 'loaded.html';
var webPage = require('webpage');
var page = webPage.create();
page.settings.userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:30.0) Gecko/20100101 Firefox/30.0';

page.open(url, function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();
});
