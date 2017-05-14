TeamUndies: Market Analysis Using Free Resources
========================================================
author: Cesar Espitia, Ilya Kats and Michael Muller
date: May 18, 2017
autosize: true

Contents
========================================================

Problem  
Methodology and Data Collection  
Validation  
Analysis  
Conclusion

Problem
========================================================


A new underwear brand is being launched that caters to the larger, more stylish gentlemen.  

A boxer brief has been developed by the founders but they also need to offer one more type and need to know how to price it.  

This information is provided by resources like Mintel, IBISWorld or Gartner but are cost prohibitive (single analysis upwards of $1,000 at times)

The goal of this project is to find <b>freely available</b> data to create a market analysis that will help them in answering the question:  

<center><b><i>What other underwear type do I develop and how do I price it?</i></b></center>

Methodology and Data Collection
========================================================

The data was collected by using information found on retailers websites.  Those chosen were:
- Bloomingdales (www.bloomingdales.com)
- Nordstrom (www.nordstrom.com)
- Calvin Klein (www.calvinklein.com)

Data was collected from retailers in the first week of May 2017. Other websites were originally considered but the three above provided a good sample for analysis.  

To further round out the data collection, data from a government source was used to determine household spend on particular goods.  

The Bureau of Labor Statistics (BLS) had a consumer expenditure diary data. The data downloaded was from Quarter 1 in 2015 only for category 200 (Undergarments) (source: https://www.bls.gov/cex/).  


Methodology and Data Collection
========================================================

Webscraping / Datascraping

Webscraping was conducted on Bloomingdales, Calvin Klein, and Nordstrom US websites.

Initial analysis of their source code revealed similar frame works; meaning designing a script to scrape one site would be a foundation for the other two.

The links to all male undergarments of each site were first obtained and transformed to assure only relevant information was to be collected; each link to become an observation.

All attributes were extracted through rvest, xpath, and regular expressions; iteratively adjusted for consistency and tested between dissimilar cases. 

Output format : .csv



Problems and Solutions for Data Collection
========================================================

AJAX - "the method of exchanging data with a server and updating parts of a web page, without reloading the entire page" or (asynchronous Javascript and XML)

- In order to gather any data from any of these websites; it was necessary for each page scraped, to tell the active javascript engine "I have observed the webpage, and would like to see X, Y, and Z"

- To talk with the active javascript, it was necessary to bypass bot detection.

To accomplish both tasks, a "phantom browser" called PhantomJS (PJS) was called between each web request and data extraction; controlled via javascript.

- The PJS assumed the identity of a firefox browser via a modified http request profile.

- Inserted "human-like" random delays between requests to avoid bot detection.

- Saved each page 'as is' to be re-loaded as complete HTML for data extraction.

Validation (Retail Sites)
========================================================

A total of 511 rows of data were collected from Bloomingdales, Nordstrom and CK.  

To determine the validity of the data, a histogram of price, a histogram of price by underwear type, and a normal QQ plot are shown below.  

<center>![my image](TeamUndies-figure/price2.jpeg)
![my image](TeamUndies-figure/validatedata.jpeg)</center>

The overall price histogram looks normally distributed and the QQ plot to show little to no abnormalities.  

Validation (BLS)
========================================================

A total of 825 rows of consumer purchasing data were collected from the Bureau of Labor Statistics on undergarment spend for the first quarter in 2015 for all genders.  

To determine the validity of the data, a histogram of overall spend, a histogram of overall spend by income class, and a normal QQ plot are shown below.  

<center>![my image](TeamUndies-figure/spend2.jpeg)
![my image](TeamUndies-figure/BLSvalidate.jpeg)</center>

The data is heavily right skewed.  Although not normally distributed, the data will be included for analyiss to provide guidance.  

Analysis (Retail)
========================================================

Since the goal is to determine a secondary underwear type to develop and the price point, the choice become apparent that an ANOVA analysis would be more appropriate across the undergarment types.  

<center>$H_0$: There is no difference in pricing by underwear type.   
$H_A$: There is a difference in pricing by underwear type.</center>

The results of the analysis show that there is a difference since the probability is <b>Pr(>F) = 2.8e-8.</b>

<center>![my image](TeamUndies-figure/ANOVATypePrice.jpeg)</center>

Analysis (BLS)
========================================================

Separately, an analysis was done on potential customers to target in a potential marketing campaign was also provided.  An ANOVA analysis was also used to determine if there is a difference between the income classes. 

<center>$H_0$: There is no difference in spend between income classes.  
$H_A$: There is a difference in spend between income classes.</center>

The results of the analysis show that there is a difference since the probability is <b>Pr(>F) = 0.01</b>

<center>![my image](TeamUndies-figure/ANOVABLS.jpeg)</center>

From our validation, this data is heavily right skewed which may invalidate this statistical test.  

The information is valid, however, for descriptive purposes as a guiding factor for the company in terms of who to target.

Conclusion
========================================================

The data collected will provide strong guidance to the startup brand to determine what direction they should take.

- They should consider <b>trunks</b> as the secondary type based upon prevalency in the retail space at an approximate <b>price point of $25-$35 a pair</b>.

- They should also consider a marketing campaign based upon income as a factor.  

- Those with a household income of greater than $50,000 tended to have a higher spend in the undergarment category.  

Appendix A
========================================================

Additional Plots for Retailer Data.  

Material vs. Price and Color vs Price. 

<center>
![my image](TeamUndies-figure/MaterialPrice.jpeg)
![my image](TeamUndies-figure/ColorPrice.jpeg)
</center>

Appendix B (Code Part 1)
========================================================

<center>
![my image](TeamUndies-figure/Code1.png)
</center>

Appendix B (Code Part 2)
========================================================

<center>
![my image](TeamUndies-figure/Code2.png)
</center>

Appendix B (Code Part 3)
========================================================

<center>
![my image](TeamUndies-figure/Code3.png)
</center>


