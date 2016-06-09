# Cloud Service Analysis

Currently ChalkFull makes use of a server farm and is looking to move to the cloud. However the team has little knowledge of this realm and so any platform that suits their needs and costs will suffice. With a back-end using python and front-end using JavaScript, technologies which are widely supported, they should have no issue finding a solution with Google, Amazon, or DigitalOcean. Since they are using a python stack, Microsoft's Azure platform would likely not be a good fit.

The company is also looking to use MongoDB which is readily provisionable through AWS using Cloud Manager Standard at a cost of [$39 USD per month][1] as of July 6, 2016. However they will also have the option to host in any other cloud provider if they wish to do the work manually. 

Dealing with elementary and secondary schools (assuming US), there isn't limitation to where the servers need to be hosted, and as such doesn't disqualify any of the remaining 3 services.

Assuming each school has 5-10 GB worth of data averaging out to 7.5GB, and only 10% of their clients use the self hosted option they currently deal with about 31.5TB (7.5 * 4680 * 0.90) of data in their server farm. 

Estimating a current [100 000][2] public elementary schools and an additional [30 000][2] which are private totaling 130 000 and given ChalkFull's market share (12% of 30%) they deal with approximately 4680 schools. And applying the same math to teachers based on 2012 numbers of [3 109 101][3] there are approximately 111 928 teachers using the system. Assuming each page served by the application is about 25KB in size, and 20 page views per teacher on a regular day we get 512KB * 111 928 = 57 307 136KB or 57.3GB making it 573.0GB on high traffic days since there is a known 10x increase.

    (244 * 57.3GB) / 12  = 1.1651TB / month
    (109 * 573.0GB) / 12 = 5.2048TB / month
                         = 6.3699TB / month average
    or 6.4TB of transfer per month.
    
_56 days added to high usage, and subtracted from regular for 2 3-week high usage periods at the beginning of each term._

It's hard to say how much data will be uploaded by the teachers for the first quarter of release, but if a quota is put in place of 50MB per month per teacher, and if everyone hits their quota it's only 5.6TB (50MB * 112 000) for the first month max.
I will assume a 25% usage of quotas across the board equaling 1.12TB increase in space for 3 months.

## Cost Analysis

In all cases I assume everyday usage based on the above averages, and estimations. 6.4TB transfer / month and a 1.12TB increase in storage per month without compression. 109 days is approximately 4 months of high usage, leaving 8 months worth of regular usage. Where there would be: 

* 2 production servers 
* 1 staging server 
* 3 database servers for regular use 
* 2 high load servers

All of which are used primarily between the hours of 07:00 AST to 20:00 PST (10:00 UTC - UTC 03:00 UTC) 17 hours.

### Google
#### [Compute][5]

* 2 production servers: ($0.775/hr * 17hrs) * 2 * 224days = $5902.40
* 1 staging server: 4 weeks (1 wk/qtr) * 0.05/hr * 24 = $67.20
* 3 database servers for all use: 0.04 * (1120 + 2240 + 3360) = $268.8/month for 3 months * 3 = $806.4
* 2 high load servers: *0.057/hr * 2 * 109days * 17hrs = $211.24

__Total: $6987.24 / year__

### Amazon Web Services
#### [EC2][7]

* 2 production servers: c3.large on a 1-yr term which is $542 * 2 = $1084
* 1 staging server: c3.large on a month-to-month: 4wks * 0.105/hr * 24 = $141.12
* 2 high load servers: c3.2xlarge month-to-month: 0.42/hr * 17hr * 109days * 2 = $1556.52

#### [S3][8]
* 3 database servers for all use: 

But it being a new feature and adoption will ramp up. $0.03/GB for first TB then $0.0295 for 0.120TB Costing:

    (0.03 * 1000) + (0.0295 * 120) = $33.54 / month * 3months * 3 servers = $301.86

__Total: 3083.5 / year__

#### [DigitalOcean][9]

Though this looks good at first due to it's low rates and capable processors and transfer, storage space comes at a premium. With a minimum of 1.12TB of data needing to be stored and accessed this option becomes inviable very fast. As the top tier of $640/month is overkill with everything but size maxing out at 640GB meaning a minimum of $1280/month would need to be spent, which is way too much for storage alone. 

## Conclusion

DigitalOcean is the simpler of the 3 in terms of offerings. They are simple and plans
increase in a linear fashion, which would make it easy to use for a trial, or app that would be stand alone, without much variability, so it doesn't quite suit the needs of the company in addition to the incredible cost of storage mentioned above.

Google's cloud compute offers the easiest set, with automatic discounts based on usage, and a small set of preset severs that auto-scale as well as a custom one. It's hard to determine what you costs will be month-to-month without some guessing, particularly on a new feature like this. And with those estimates it's twice as much as Amazons.

Leaving the best option to be AWS. Amazon's services are very granular and lend well to fine tunning for economic purposes. And with the option of paying yearly upfront with a discounted rate for overages it wasn't a lot of work to calculate the cost of service.


[1]: https://www.mongodb.com/cloud
[2]: https://nces.ed.gov/fastfacts/display.asp?id=84
[3]: http://nces.ed.gov/programs/digest/d14/tables/dt14_208.30.asp?current=yes
[4]: http://www.free-webhosts.com/bandwidth-calculator.php
[5]: https://cloud.google.com/compute/
[7]: https://aws.amazon.com/ec2/pricing/
[8]: https://aws.amazon.com/s3/pricing/
[9]: https://www.digitalocean.com/pricing/
