#import "GsbridgePlugin.h"

@implementation GsbridgePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"gsbridge"
            binaryMessenger:[registrar messenger]];
  GsbridgePlugin* instance = [[GsbridgePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"authenticate" isEqualToString:call.method]) {
     NSDictionary<NSString *, id> *_result = @{
                @"status" : @"success",
                @"authToken" : @"",
                @"displayName" : @"",
                @"authToken" : @"",
                @"newPlayer" : @"",
                @"switchSummary" : @"",
                @"userId" : @"",
            };
     result(_result);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
