#import "GsbridgePlugin.h"
#import "GS.h"
#import "GSAPI.h"

@implementation GsbridgePlugin

static GS *gs;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    gs = [[GS alloc] initWithApiKey:@"q391231asyX3" andApiSecret:@"sCLhBW8pr4a1gbRv5t2labw07pJST6Jf" andCredential:@"device" andPreviewMode:true];
    /*
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
     */
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
        [request setPassword:call.arguments[@"password"]];
        [request setUserName:call.arguments[@"username"]];
        [request setCallback:^ (GSAuthenticationResponse* response) {
            NSString* authToken = [response getAuthToken];
            NSString* displayName = [response getDisplayName];
            NSNumber* newPlayer = [NSNumber numberWithBool:[response getNewPlayer]];
            // TODO           NSDictionary* scriptData = [response getScriptData];
            // TODO           GSPlayer* switchSummary = [response getSwitchSummary];
            NSString* userId = [response getUserId];
            
            NSMutableDictionary<NSString *, id> *_result = [[NSMutableDictionary alloc] init];
            [_result setValue:@"success" forKey:@"status"];
            [_result setValue:authToken forKey:@"authToken"];
            [_result setValue:(displayName ? displayName : [NSNull null]) forKey:@"displayName"];
            [_result setValue:newPlayer forKey:@"newPlayer"];
            // TODO           [_result setValue:(switchSummary ? switchSummary : [NSNull null]) forKey:@"switchSummary"];
            // TODO           [_result setValue:(scriptData ? scriptData : [NSNull null]) forKey:@"scriptData"];
            [_result setValue:userId forKey:@"userId"];
            
            result(_result);
            
            
        }];
        [gs send:request];
    } else if ([@"registration" isEqualToString:call.method]) {
        
        GSRegistrationRequest* request = [[GSRegistrationRequest alloc] init];
        
        [request setPassword:call.arguments[@"password"]];
        [request setUserName:call.arguments[@"username"]];
        [request setDisplayName:call.arguments[@"displayName"]];
        [request setCallback:^ (GSRegistrationResponse* response) {
            if ([response getErrors].count == 0) {
                NSString* authToken = [response getAuthToken];
                NSString* displayName = [response getDisplayName];
                NSNumber* newPlayer = [NSNumber numberWithBool:[response getNewPlayer]];
                //            NSDictionary* scriptData = [response getScriptData];
                GSPlayer* switchSummary = [response getSwitchSummary];
                NSString* userId = [response getUserId];
                
                NSMutableDictionary<NSString *, id> *_result = [[NSMutableDictionary alloc] init];
                [_result setValue:@"success" forKey:@"status"];
                [_result setValue:authToken forKey:@"authToken"];
                [_result setValue:(displayName ? displayName : [NSNull null]) forKey:@"displayName"];
                [_result setValue:newPlayer forKey:@"newPlayer"];
                [_result setValue:(switchSummary ? switchSummary : [NSNull null]) forKey:@"switchSummary"];
                [_result setValue:userId forKey:@"userId"];
                
                result(_result);
            } else {
                NSMutableDictionary<NSString *, id> *_result = [[NSMutableDictionary alloc] init];
                [_result setValue:@"failure" forKey:@"status"];
                [_result setValue:[GsbridgePlugin dictionaryToJSONString:[response getErrors]] forKey:@"errors"];
                result(_result);
            }
            
            
        }];
        [gs send:request];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

+(NSString*) dictionaryToJSONString:(NSDictionary*)dictionary {
    //    NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
