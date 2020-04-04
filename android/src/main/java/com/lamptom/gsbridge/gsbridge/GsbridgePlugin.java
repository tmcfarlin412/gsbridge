package com.lamptom.gsbridge.gsbridge;

import android.media.MediaRouter;
import android.telecom.Call;

import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.Lifecycle;

import com.gamesparks.sdk.GSEventConsumer;
import com.gamesparks.sdk.android.GSAndroidPlatform;
import com.gamesparks.sdk.api.autogen.GSResponseBuilder;
import com.gamesparks.sdk.api.autogen.GSTypes;

import org.json.simple.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.BuildConfig;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference;
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
  final static String STATUS_SUCCESS = "success";
  final static String STATUS_FAILURE = "failure";
  final static String STATUS_FAILURE_REGISTRATION_USER_TAKEN = "failure - username taken";

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    boolean liveMode = false;
    boolean autoUpdate = true;
    HiddenLifecycleReference reference = (HiddenLifecycleReference) binding.getLifecycle();
    GSAndroidPlatform.initialise(binding.getActivity(), "q391231asyX3", "sCLhBW8pr4a1gbRv5t2labw07pJST6Jf", "device", liveMode, autoUpdate);
    GSAndroidPlatform.gs().setOnAvailable(new GSEventConsumer<Boolean>() {
      @Override
      public void onEvent(Boolean _available) {
      }
    });
    GSAndroidPlatform.gs().start();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
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
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("authenticate")) {
      authenticate((String) call.argument("username"), (String) call.argument("password"), new Callback() {
        @Override
        public void onSuccess(Object _result) {
          result.success(_result);
        }

        @Override
        public void onFailure(Object _result) {
          result.error(STATUS_FAILURE, "Authentication error", _result);
        }
      });
    } else if (call.method.equals("registration")) {
      registration((String) call.argument("displayName"), (String) call.argument("language"), (String) call.argument("username"), (String) call.argument("password"), new Callback() {
        @Override
        public void onSuccess(Object _result) {
          result.success(_result);
        }

        @Override
        public void onFailure(Object _result) {
          result.error(STATUS_FAILURE, "Authentication error", _result);
        }
      });
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  // Authenticate user
  private void authenticate(String username, String password, final Callback callback) {
    GSAndroidPlatform.gs().getRequestBuilder().createAuthenticationRequest().setUserName(username).setPassword(password).send(new GSEventConsumer<GSResponseBuilder.AuthenticationResponse>() {
      @Override
      public void onEvent(GSResponseBuilder.AuthenticationResponse response) {
        Map<String, Object> result = new HashMap<>();
        if (!response.hasErrors()) {
          result.put("status", STATUS_SUCCESS);
          result.put("authToken", response.getAuthToken());
          result.put("displayName", response.getDisplayName());
          result.put("newPlayer", response.getNewPlayer());
          result.put("switchSummary", response.getSwitchSummary());
          result.put("userId", response.getUserId());
          callback.onSuccess(result);
        } else {
          result.put("status", STATUS_FAILURE);
          callback.onFailure(result);
        }
      }
    });
  }

  // Register user
  private void registration(String displayName, String language, String username, String password, final Callback callback) {
    GSAndroidPlatform.gs().getRequestBuilder().createRegistrationRequest()
            .setDisplayName(displayName)
            .setUserName(username)
            .setPassword(password)
            .send(new GSEventConsumer<GSResponseBuilder.RegistrationResponse>() {
              @Override
              public void onEvent(GSResponseBuilder.RegistrationResponse response) {
                Map<String, Object> result = new HashMap<>();
                if (!response.hasErrors()) {
                  result.put("status", STATUS_SUCCESS);
                  result.put("authToken", response.getAuthToken());
                  result.put("displayName", response.getDisplayName());
                  result.put("newPlayer", response.getNewPlayer());
                  result.put("switchSummary", response.getSwitchSummary());
                  result.put("userId", response.getUserId());
                  callback.onSuccess(result);
                } else {
                  JSONObject error = ((JSONObject) response.getBaseData().get("error"));
                  if (error.get("USERNAME").equals("TAKEN")) {
                    result.put("status", STATUS_FAILURE_REGISTRATION_USER_TAKEN);
                  } else {
                    result.put("status", STATUS_FAILURE);
                  }
                  callback.onFailure(result);
                }
              }
            });
  }

  //define callback interface
  interface Callback {
    void onSuccess(Object _result);

    void onFailure(Object _result);
  }
}
