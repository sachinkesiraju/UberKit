UberKit
=======

UberKit is a simple Objective-C wrapper for the new <a href = http://developer.uber.com> Uber API </a>.

<h1> Installation </h1>
<h3> Cocoapods </h3>
UberKit is available through <a href = "cocoapods.org"> Cocoapods</a>. To install it, simply add the following to your Podfile.
```
pod 'UberKit'
```
<h3> Alternative </h3>
Alternatively, you can always just drag and drop the folder 'UberKit' into your project and ``#import "UberKit.h"`` and you're good to go.

<h2> Basic API Implementation </h2>

This is to implement the Uber API without having users sign in to their Uber account.

To implement UberKit, first initialize it with your server token

You can get your server token from <a href = http://developer.uber.com> Uber Developers </a>

```objc
  UberKit *uberKit = [[UberKit alloc] initWithServerToken:@"YOUR_SERVER_TOKEN"];
```
Alternatively, you can set your server token to an instance of UberKit as follows:
```objc
    [[UberKit sharedInstance] setServerToken:@"YOUR_SERVER_TOKEN"];
```

To get all products available from a particular location

```objc
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
```objc
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
```objc
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

To get the available promotion for a trip between two locations
```objc
[uberKit getPromotionForLocation:location endLocation:endLocation withCompletionHandler:^(UberPromotion *promotion, NSURLResponse *response, NSError *error)
     {
        if(!error)
        {
            //Got the promotion as an UberPromotion
        }
        else
        {
            NSLog(@"Error %@", error);
        }
     }];
```

<h2> OAuth implementation </h2>

<h3> Introduction </h3>

This is to implement the Uber API with endpoints that require user authorization such as user history and profile.
The authorization process is implemented by:

1. Allowing the users to sign in to their Uber accounts.

2. Obtaining an access token on user approval of app's permissions.

3. Using this access token to make calls to the Uber API.

UberKit automatically opens a web view within your app through which the users enter their Uber login credentials to allow access to their profiles. 

<img src = "https://github.com/sachinkesiraju/UberKit/blob/master/Login%20screenshot.png" width = "320px">

<h3> Implementation </h3>

Before you can get started using UberKit with login parameters, you must first create an Uber application at <a href = http://developer.uber.com> Uber Developers </a> and fill in all necessary fields.

<b> [Note: To gain access to the user's profile and history, ensure that you have these permissions enabled in your app's dashboard] </b>

To implement UberKit with authorization from the user first initialize it with your client id, client secret, redirect URI and application name from the application you made on Uber Developer.

```objc
UberKit *uberKit = [[UberKit alloc] initWithClientID:@"YOUR_CLIENT_ID" ClientSecret:@"YOUR_CLIENT_SECRET" RedirectURL:@"YOUR_REDIRECT_URL" ApplicationName:@"YOUR_APPLICATION_NAME"]; //Set these fields from your app on Uber Developers.
uberKit.delegate = self; //Set the delegate (only for login)
```

Add the UberKit delegate to the @interface of your view controller to detect when an Uber access token becomes available for use after successful authorization. Then, you must add the following methods to your view controller:
```objc
- (void) uberKit: (UberKit *) uberKit didReceiveAccessToken: (NSString *) accessToken
{
    //Got the access token, can now make requests for user data
}
- (void) uberKit: (UberKit *) uberKit loginFailedWithError: (NSError *) error
{
    //An error occurred in the login process
}
```
You can also retrieve the access token when it is available by using `NSString *token = [[UberKit sharedInstance] getStoredAuthToken];`

To begin the login process, call the method 'startLogin' by passing your view controller using `[uberKit startLoginWithViewController:self];`

Once you've successfully retrieved an access token, you can then make the following calls to the Uber API :

To get all activity by the user
```objc
[uberKit getUserActivityWithCompletionHandler:^(NSArray *activities, NSURLResponse *response, NSError *error)
         {
             if(!error)
             {
                 //Got an array of the history of activities performed by the user
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
```

To get the profile of the user
```objc
[uberKit getUserProfileWithCompletionHandler:^(UberProfile *profile, NSURLResponse *response, NSError *error)
         {
             if(!error)
             {
                 //Got the user's profile as an UberProfile
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
```

For more help, check out the <a href = https://github.com/sachinkesiraju/UberKit/tree/master/UberKitDemo> Demo </a>!

For any assistance, reach out to me on Twitter <a href = https://twitter.com/sachinkesiraju> @sachinkesiraju </a>

<h2> Featured In </h2>

- <a href = http://blindsquare.com/>Blindsquare </a>

Let me know where you use UberKit so I can add it here!

<h2> Community </h2>

If you feel that you can contribute to improving UberKit or add a new feature, feel free to raise an issue/submit a PR.

<h2> License </h2>

UberKit is available under the MIT License. See the <a href = https://github.com/sachinkesiraju/UberKit/blob/master/LICENSE>LICENSE</a> for more information.
