package com.ziggeo;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.ziggeo.modules.ZiggeoPlayerModule;
import com.ziggeo.modules.ZiggeoRecorderModule;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by alex on 6/25/2017.
 */

public class ZiggeoPackage implements ReactPackage {

    private static final String TAG = ZiggeoPackage.class.getSimpleName();

    @Override
    public List<NativeModule> createNativeModules(@NotNull ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        modules.add(new ZiggeoRecorderModule(reactContext));
        modules.add(new ZiggeoPlayerModule(reactContext));

        return modules;
    }

    @Override
    public List<ViewManager> createViewManagers(@NotNull ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }

}
