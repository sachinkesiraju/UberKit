UberKit
=======

<b>By <a href = https://twitter.com/sachinkesiraju> @sachinkesiraju </a></b>

UberKit is a simple Objective-C wrapper for the new <a href = http://developer.uber.com> Uber API </a>.

<h2> Installation </h2>

To add UberKit to your iOS app, add the UberKit folder to your project and `#import UberKit.h` 

<h2> Implementation </h2>

To implement UberKit, first initialize it with your server token

You can get your server token from <a href = http://developer.uber.com> Uber Developers </a>

```
  UberKit *uberKit = [[UberKit alloc] initWithServerToken:@"YOUR_SERVER_TOKEN"];
```

To get all products available from a particular location

```
 [uberKit getProductsForLocation:location withCompletionHandler:^(NSArray *products, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             //Got the array of available products for the location.
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
```

To get the time for arrival of a product to a particular location
```
[uberKit getTimeForProductArrivalWithLocation:location withCompletionHandler:^(NSArray *times, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             //Got the array of available products and the time they'll take to reach the mentioned location.
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
```

To get the price for a trip between two locations
```
[uberKit getPriceForTripWithStartLocation:location endLocation:endLocation  withCompletionHandler:^(NSArray *prices, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             //Got the array of available products and the price of a trip from the start location to the end location.
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
```
For more help, check out the <a href = https://github.com/sachinkesiraju/UberKit/tree/master/UberKitDemo> Demo </a>!

<h2> License </h2>

UberKit is available under the MIT License. See the <a href = https://github.com/sachinkesiraju/UberKit/blob/master/LICENSE>LICENSE</a> for more information.
