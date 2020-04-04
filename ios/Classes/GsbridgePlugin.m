#import "GsbridgePlugin.h"
#import "GS.h"
#import "GSAPI.h"

@implementation GsbridgePlugin

static GS *gs;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    gs = [[GS alloc] initWithApiKey:@"q391231asyX3" andApiSecret:@"sCLhBW8pr4a1gbRv5t2labw07pJST6Jf" andCredential:@"device" andPreviewMode:true];
    [gs setAvailabilityListener:^ (BOOL available) {
        NSLog(@"Gsbridge: GS availablilty listener!");
    }];
    
    [gs setAuthenticatedListener:^(NSString* playerId) {
        NSLog(@"Gsbridge: GS authenticated listener!");
    }];
    
    GSMessageListener* listener = [[GSMessageListener alloc] init];
    
    [listener onGSScriptMessage:^(GSScriptMessage* message) {
        NSLog(@"%@", message);
    }];
    
    [gs setMessageListener:listener];
    [gs connect];
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"gsbridge"
                                     binaryMessenger:[registrar messenger]];
    GsbridgePlugin* instance = [[GsbridgePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"authenticate" isEqualToString:call.method]) {
        
        GSAuthenticationRequest* request = [[GSAuthenticationRequest alloc] init];
        
        [request setPassword:@"test"];
        [request setUserName:@"test"];
        [request setCallback:^ (GSAuthenticationResponse* response) {
            NSString* authToken = [response getAuthToken];
            NSString* displayName = [response getDisplayName];
            //BOOL newPlayer = [response getNewPlayer];
            //NSDictionary* scriptData = [response getScriptData];
            GSPlayer* switchSummary = [response getSwitchSummary];
            NSString* userId = [response getUserId];
            NSDictionary<NSString *, id> *_result = @{
                @"status" : @"success",
                @"authToken" : authToken,
                @"displayName" : displayName,
                @"newPlayer" : @"tmp",
                @"switchSummary" : switchSummary,
                @"userId" : userId,
            };
            result(_result);
            
            
        }];
        [gs send:request];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
