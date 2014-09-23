UberKit
=======

UberKit is a simple Objective-C wrapper for the new <a href = http://developer.uber.com> Uber API </a>.

<h1> Installation </h1>

To add UberKit to your iOS app, add the UberKit folder to your project and `#import UberKit.h` 

<h2> Basic API Implementation </h2>

This is to implement the Uber API without having users sign in to their Uber account.

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
<h2> OAuth implementation </h2>

<h3> Introduction </h3>

This is to implement the Uber API with endpoints that require user authorization such as user history and profile.
The authorization process is implemented by:

1. Allowing the users to sign in to their Uber accounts through the iOS Safari browser.

2. Obtaining an access token on user approval of app's permissions.

3. Using this access token to make calls to the Uber API.

<h3> App Setup </h3>

<b>Step 1</b>: Create an Uber application at <a href = http://developer.uber.com> Uber Developers </a>

<b>Step 2</b>: As a part of the application set up in Step 1, set the redirect URI to one that your app can uniquely identify. This is so that you are able to redirect back to your application after receiving authentication from the Safari app.

Eg: sachinkesiraju://uberkit which redirects back to your app's custom URL scheme. (Make sure the name in place of "sachinkesiraju" is unique to your app)

<b>[Note: Since Uber only accepts redirect URI's in the format, https or localhost, one way you can redirect back to safari is by setting the redirect URI here to your server where you can detect if the request came from safari and open your application if it is installed. I am open to suggestions on how to do this more efficiently]</b>

<b>Step 3</b>: So that the redirect URL in step 2 can redirect back to your application, we must create a custom URL scheme in our applications Info.plist file. To do this:
- Navigate to your app's Info.plist file.
- Add a new row by going to the menu and clicking Editor > Add Item.
- Select URL types, expand Item 0, add a new item: "URL Schemes" set it to the value you had in place of "sachinkesiraju" in your custom URL scheme.
- Under URL types, add another item, Item 1 named "URL identifier" and set it to the value you have in place of "uberkit" in the example.

<b> [Note: The example shown above must be used here even if your redirect URI for your application redirects to your own server. This is because your server needs to be able to identify your app with this URL Scheme] </b>

<b> Step 4</b>: Add the following method to your application's AppDelegate.m to allow redirect from Safari back to the app.
```
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([[UberKit sharedInstance] handleLoginRedirectFromUrl:url sourceApplication:sourceApplication])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
```

<h3> Implementation </h3>

To implement UberKit with authorization from the user first initialize it with your client id, client secret, redirect URI and application name from the application you made on Uber Developer.

```
UberKit *uberKit = [[UberKit alloc] initWithClientID:@"YOUR_CLIENT_ID" ClientSecret:@"YOUR_CLIENT_SECRET" RedirectURL:@"YOUR_REDIRECT_URL" ApplicationName:@"YOUR_APPLICATION_NAME"];
```

Alternatively, you can set these values to an instance of UberKit as follows:
```
    [[UberKit sharedInstance] setClientID:@"YOUR_CLIENT_ID"]; 
    [[UberKit sharedInstance] setClientSecret:@"YOUR_CLIENT_SECRET"]; 
    [[UberKit sharedInstance] setRedirectURL:@"YOUR_REDIRECT_URL"]; 
    [[UberKit sharedInstance] setApplicationName:@"YOUR_APPLICATION_NAME"];
```
In the view controller you're calling the authorization method from, add a notification observer for when an Uber access token becomes available for use after successful authorization.
```
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performActionsWithToken) name:UBER_ACCESS_TOKEN_AVAILABLE object:nil];
```
You can then retrieve the access token using `NSString *authToken = [[UberKit sharedInstance] getStoredAuthToken];`

The method 'performActionWithToken' would be where you call to the API using the access token you just received.

To begin the login process, call the method 'startLogin' as follows:
```
  [uberKit startLogin];
  OR
  [[UberKit sharedInstance] startLogin];
```

Once you receive the method 'performActionWithToken' is called, i.e when you have an access token, you may call the following methods to the API.

To get all activity by the user
```
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
```
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

<b> [Note: To gain access to the user's profile and history, ensure that you have these permissions enabled in your app's dashboard] </b>

For more help, check out the <a href = https://github.com/sachinkesiraju/UberKit/tree/master/UberKitDemo> Demo </a>!

For any assistance, reach out to me on Twitter <a href = https://twitter.com/sachinkesiraju> @sachinkesiraju </a>

<h2> License </h2>

UberKit is available under the MIT License. See the <a href = https://github.com/sachinkesiraju/UberKit/blob/master/LICENSE>LICENSE</a> for more information.
