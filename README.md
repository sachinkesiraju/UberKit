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
 [uberKit getProductsForLocationWithLatitude:START_LAT longitude:START_LONG success:^(NSArray *products)
     {
        //Got the array of available products
     }
    failure:^(NSError *error, NSHTTPURLResponse *response)
     {
         NSLog(@"Error %@", error);
     }];
```

To get the time for arrival of a product to a particular location
```
[uberKit getTimeForProductArrivalWithStartLatitude:START_LAT startLongitude:START_LONG success:^(NSArray *times)
     {
        //Got the array of available products and the time they'll take to reach the coordinates
     }
    failure:^(NSError *error, NSHTTPURLResponse *response)
     {
         NSLog(@"Error %@", error);
     }];
```

To get the price for a trip between two locations
```
[uberKit getPriceForTripWithStartLatitude:START_LAT startLongitude:START_LONG endLatitude:END_LAT endLongitude:END_LONG success:^(NSArray *prices)
     {
        //Got the array of available products and the price it will take to ride from the start point to the end point
     }
    failure:^(NSError *error, NSHTTPURLResponse *response)
     {
         NSLog(@"Error %@", error);
     }];
```
For more help, check out the demo project <a href = https://github.com/sachinkesiraju/UberKit/tree/master/UberKitDemo> Demo </a>!

<h2> License </h2>

UberKit is available under the MIT License. See the <a href = https://github.com/sachinkesiraju/UberKit/blob/master/LICENSE>LICENSE</a> for more information.
