# DNAC-IOS-Auth-Framework

This is sample Native login SDK/framework for basic authentication 

# Installation and Setup:
   
## How to integrate IOS Basic Auth framework into application.

    1. Add the Authentication.Framework to your Project Bundle (Currently named as DNAAuthentication).

    2. Add the Framework binary to your Embedded Binaries Section by going on the path mentioned below Path: <ProjectName>-><ProjectTargate>-><General>-><EmbeddedBinaries>

    3. Set Enable Bitcode Flag to NO by going to  <ProjectName>-><ProjectTargate>-><Build Settings>-><Enable Bitcode>


## How to use framework API's in application.
     1. Use import DNAAuthentication to import Framwork in a application class.
     
     2. Use DNAAuthenticationManager Class to get instance of DNALoginViewController to use it according to end developers requirement.
        
  ![alt text](https://github.com/CiscoDevNet/DNAC-SWIFT-SDK/images/LoginViewControllerExample.png)

     
     3. Use DNALoginViewControllerDelegate and confirm to <dnaLoginViewControllerInstance>.delegate for receiving callbacks from DNALoginViewController.
     
     
   ![alt text](https://github.com/CiscoDevNet/DNAC-SWIFT-SDK/images/DNALoginViewControllerDelegate.png)
   
   
   4. 	DNALoginViewControllerDelegate Callback Methods Details :

      didStartAuthenticating(): Gets invoked once authentication process starts.

      authenticationDidSucceed(): Gets invoked one authentication process was successful.

      authenticationDidFail(): Gets invoked if authentication process failed.
      
 
 ![alt text](https://github.com/CiscoDevNet/DNAC-SWIFT-SDK/images/DNALoginViewControllerDelegateCB.png)
