var url ='https://www.bloomingdales.com/shop/product/calvin-klein-edge-micro-low-rise-trunks?ID=2530157&CategoryID=1006225#fn=spp%3D51';
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
