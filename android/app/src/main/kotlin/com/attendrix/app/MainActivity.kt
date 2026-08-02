package com.attendrix.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.attendrix.app.widget.WidgetBridge

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        WidgetBridge.attach(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
    }
}
