UberKit
=======

<b>By <a href = https://twitter.com/sachinkesiraju> @sachinkesiraju </a></b>

UberKit is a simple Objective-C wrapper for the new <a href = http://developer.uber.com> Uber API </a>.

<h2> Installation </h2>

To add UberKit to your iOS app, add the UberKit folder to your project and `#import UberKit.h` 

<h2> Implementation </h2>

To implement UberKit, first initialize it

```
  UberKit *uberKit = [[UberKit alloc] init];
```
To get all products available from a particular location

```
 [uberKit getProductsForLocationWithLatitude:LAT longitude:LONG success:^(UberProduct *product)
     {
         NSLog(@"Product %@", product);
     }
    failure:^(NSError *error, NSHTTPURLResponse *response)
     {
         NSLog(@"Error %@", error);
     }];
```

To get the time for arrival of a product to a particular location
```
[uberKit getTimeForProductArrivalWithStartLatitude:LAT startLongitude:LONG success:^(UberTime *time)
     {
         NSLog(@"Time %f", time);
     }
    failure:^(NSError *error, NSHTTPURLResponse *response)
     {
         NSLog(@"Error %@", error);
     }];
```

To get the price for a trip between two locations
```
[uberKit getPriceForTripWithStartLatitude:START_LAT startLongitude:START_LONG endLatitude:END_LAT endLongitude:END_LONG success:^(UberPrice *price)
     {
         NSLog(@"Price %@", price);
     }
    failure:^(NSError *error, NSHTTPURLResponse *response)
     {
         NSLog(@"Error %@", error);
     }];
```

<h2> License </h2>

UberKit is available under the MIT License. See the <a href = https://github.com/sachinkesiraju/UberKit/blob/master/LICENSE>LICENSE</a> for more information.
