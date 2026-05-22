package com.attendrix.app

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.attendrix.app/downloads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saveImageToDownloads") {
                val bytes = call.argument<ByteArray>("bytes")
                val filename = call.argument<String>("filename")

                if (bytes == null || filename == null) {
                    result.error("INVALID_ARGUMENTS", "Bytes or filename was null", null)
                    return@setMethodCallHandler
                }

                try {
                    val filePath = saveBytesToDownloads(bytes, filename)
                    if (filePath != null) {
                        result.success(filePath)
                    } else {
                        result.error("SAVE_FAILED", "Failed to save file to downloads", null)
                    }
                } catch (e: Exception) {
                    result.error("ERROR", e.message, e.stackTraceToString())
                }
            } else if (call.method == "getAndroidVersion") {
                result.success(Build.VERSION.SDK_INT)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun saveBytesToDownloads(bytes: ByteArray, filename: String): String? {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val resolver = contentResolver
            val contentValues = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, filename)
                put(MediaStore.MediaColumns.MIME_TYPE, "image/jpeg")
                put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
            }
            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
            if (uri != null) {
                resolver.openOutputStream(uri)?.use { outputStream ->
                    outputStream.write(bytes)
                }
                return "Downloads/$filename"
            }
        } else {
            val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
            if (!downloadsDir.exists()) {
                downloadsDir.mkdirs()
            }
            val file = File(downloadsDir, filename)
            FileOutputStream(file).use { outputStream ->
                outputStream.write(bytes)
            }
            return file.absolutePath
        }
        return null
    }
}
