package com.lamptom.gsbridge.gsbridge;

import androidx.annotation.NonNull;

import com.gamesparks.sdk.GSEventConsumer;
import com.gamesparks.sdk.android.GSAndroidPlatform;
import com.gamesparks.sdk.api.AbstractResponse;
import com.gamesparks.sdk.api.autogen.GSResponseBuilder;

import org.json.simple.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;

/**
 * GsbridgePlugin
 */
public class GsbridgePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    final static private String STATUS_SUCCESS = "success";
    final static private String STATUS_FAILURE = "failure";

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {

        // TODO expose liveMode and autoUpdate to Flutter
        boolean liveMode = false;
        boolean autoUpdate = true;

        // TODO move to build script, not in VCS
        GSAndroidPlatform.initialise(binding.getActivity(), "q391231asyX3", "sCLhBW8pr4a1gbRv5t2labw07pJST6Jf", "device", liveMode, autoUpdate);
        GSAndroidPlatform.gs().setOnAvailable(_available -> {
        });
        GSAndroidPlatform.gs().start();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivity() {
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "gsbridge");
        channel.setMethodCallHandler(new GsbridgePlugin());
    }


    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "gsbridge");
        channel.setMethodCallHandler(new GsbridgePlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
        switch (call.method) {
            case "authenticate":
                GSAndroidPlatform.gs().getRequestBuilder().createAuthenticationRequest()
                        .setPassword(call.argument("password"))
                        .setUserName(call.argument("username"))
                        .send(response -> {
                            if (!response.hasErrors()) {
                                Map<String, Object> _result = new HashMap<>();
                                _result.put("status", STATUS_SUCCESS);
                                _result.put("authToken", response.getAuthToken());
                                _result.put("displayName", response.getDisplayName());
                                _result.put("newPlayer", response.getNewPlayer());
                                _result.put("switchSummary", response.getSwitchSummary());
                                _result.put("userId", response.getUserId());
                                // TODO serialize: Player switchSummary = response.getSwitchSummary();

                                result.success(_result);
                            } else {
                                prepareAndSendErrorResponse(result, response);
                            }
                        });
                break;
            case "registration":
                GSAndroidPlatform.gs().getRequestBuilder().createRegistrationRequest()
                        .setDisplayName(call.argument("displayName"))
                        .setUserName(call.argument("username"))
                        .setPassword(call.argument("password"))
                        .send(response -> {
                            if (!response.hasErrors()) {
                                Map<String, Object> _result = new HashMap<>();
                                _result.put("status", STATUS_SUCCESS);
                                _result.put("authToken", response.getAuthToken());
                                _result.put("displayName", response.getDisplayName());
                                _result.put("newPlayer", response.getNewPlayer());
                                _result.put("switchSummary", response.getSwitchSummary());
                                _result.put("userId", response.getUserId());

                                result.success(_result);
                            } else {
                                prepareAndSendErrorResponse(result, response);
                            }
                        });
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void prepareAndSendErrorResponse(@NonNull final Result result, AbstractResponse response) {
        Map<String, Object> _result = new HashMap<>();
        _result.put("status", STATUS_FAILURE);

        // Convert error to JSON object, add to result
        JSONObject error = ((JSONObject) response.getBaseData().get("error"));
        if (error != null) {
            _result.put("errors", error.toJSONString());
        }

        result.success(_result);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
}
