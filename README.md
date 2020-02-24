# cyberpay-ios (Depreciated)
This product is now obsolete, and we recommend you use: https://github.com/cyberspace-ltd/cyberpay-iosx
The Cyberpay SDK makes it quick and easy to build seamless payment into your iOS app. The SDK contains custom views, and helps in managing the Cyberspace API.

## Features
The SDK provides custom native UI elements to get you started easily without having to design the elements yourself.

## Releases
We recommend that you install the Cyberpay SDK using the Cocoapods package manager.

## Requirements
The Cyberpay iOS SDK is compatible with iOS Apps supporting IOS 9 and above.

## Getting Started

### Install and Configure the SDK
1. If you haven't already, install the latest version of CocoaPods
2. Add this line to your podfile
	`pod 'cyberpaysdk', :git => 'https://github.com/cyberspace-ltd/cyberpay-ios.git', :tag => '1.1.3'`

3. Run the following command in your terminal after navigating to your project directory.
	`pod install`

4. Ensure you use the **.xcworkspace** file to open your project in Xcode instead of **.xcodeproj**.


### Configure your Cyberpay integration in your App Delegate
**Step 1**: Configure API Keys
After installation of the Cyberpay SDK, configure it with your API Integration Key gotten from your merchant dashboard, for test and production
```swift
import UIKit
import cyberpaysdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        CyberpaySDK.shared.initializeTestEnvironment(key: "TEST_API_KEY")
        
//        CyberpaySDK.shared.initializeLiveEnvironment(key: "LIVE_API_KEY")
        
        return true
    }
```
**Note** : Ensure when going live, you initialize the Live API key `CyberpaySDK.shared.initializeLiveEnvironment(key: "LIVE_API_KEY")` instead of the Test API key `CyberpaySDK.shared.initializeTestEnvironment(key: "TEST_API_KEY")`. This key can be gotten from the merchant
dashboard on the cyberpay merchant portal

**Step 2**: Collect Credit Card Information.
**Note** : We have a prebuilt form components to collect all card information, `CPCardNumberTextField`, `CPCVVTextField`, `CPExpiryDateField` to collect card number, cvv and dates respectively

```swift
        var transaction = CPTransactionParams()
    
        var card = CPCardParams()
  
        let cardNumber = self.cardNumberTextField.text!
        card.number = cardNumber.replacingOccurrences(of: " ", with: "")//removing the whitespace
        
        card.cvv = self.cvvTextField.text!
        card.expMonth = Int(self.expiryDateTextField.month)!
        card.expYear = Int(self.expiryDateTextField.year)!
        
        let amount = Double.init(amountTextField.text!)
        
        let amountInKobo = amount! * 100
        
        transaction.amountInKobo = amountInKobo
        transaction.description = "Sample transaction from iOS SDK"
        
        //Add Optional Merchant Transaction reference
        //transaction.merchantReference
        

```
**Step 3** : Initialise the transaction
```swift

//The beginTransaction method returns a transaction Reference in the `onSuccess()` callback. Assign this transaction reference to the `transactionParameter` provided in the previous 
//step and call the charge card method

 CyberpaySDK.shared.beginTransaction(param: transaction, onSuccess: { (transactionReference) in
                        
            self.transaction.transactionReference = transactionReference
            
            //call the charge card function on succuss of initialising transaction
            
            
        }) { (error) in
            
            //display error message
            
        }
```
**Step 4**: Charge Card providing the Card Parameters provided in **Step 2**

```swift

     CyberpaySDK.shared.chargeCard(param: card, transactionRef: transaction.transactionReference, onSuccess: { (transRef) in
            
            
        //Your transaction was successful            
            
        }, onOtpRequired: { (transRef) in
            
            //Otp Required, go to otp view
            
            
        }) { (error) in
            
            //display error
        }

```
**Note**: The chargeCard() method returns 3 callbacks: `onSuccess()`, which means your transaction was successful and returns the transaction Reference, `onOtpRequired()`, which means an otp is required to verify this transaction,
and also returns the transaction reference, `onError()`, which returns an error message, when chargeCard() fails.

**Step 5** : Verify OTP
When a verification is required, the Otp verification method is called.
Attach an otp gotten from the user to the transaction parameter created in **Step 2**

```swift
   if transaction != nil {
            
            transaction?.otp = otpTextField.text!
            
            CyberpaySDK.shared.verifyOtp(param: transaction!, onSuccess: { (transactionReference) in
                
                //otp verification was successful & card was charged
                
            }) { (error) in
            
               //otp verification failed
            }
            
        }
```
**Note**: Other methods for the cyberpay SDK exist which include verification of transaction by the merchant reference, and also by the transaction Reference.
Methods of the SDK can be accessed by adding `import cyberpaysdk`
```swift

  import UIKit
  import cyberpaysdk
```
and calling `CyberpaySDK.shared`

## Getting Started With The Sample iOS Example
1. To View an example implementation of this project download the **CyberpayExample** of this repository, and run a `pod install` from your terminal, after navigating to the folder.
2. Ensure you use the **.xcworkspace** file to open your project in Xcode instead of **.xcodeproj**.
3. Replace the `TEST_API_KEY` in the `CyberpaySDK.shared.initializeTestEnvironment(key: "TEST_API_KEY")` in the `AppDelegate.swift` file with your test integration key gotten from your merchant dashboard.
4. Run the Sample Application. Two major sample views were provided to showcase the SDK. `ViewController.swift` & `OtpViewController.swift`

## Test Card
After running the app, We have provided a test card to test the OTP flow instead of using live cards.

```swift
Card Number: 5399830000000008,
Exp. Date: 05/30, 
CVV: 000,
OTP:123456

````

