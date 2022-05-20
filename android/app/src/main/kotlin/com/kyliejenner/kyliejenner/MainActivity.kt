package com.kyliejenner.kyliejenner

import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File


class MainActivity: FlutterActivity() {

    private var CHANNEL = "wallpaper";


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, _ ->
            if (call.method == "setWallpaper") {
                val filePath: String = call.argument("url")!!
                val file = File(filePath);
                val uri : Uri = FileProvider.getUriForFile(context, context.packageName + ".provider", file);
                onClickSetWallpaper(uri)
            }
        }
    }

    private fun onClickSetWallpaper(uri: Uri) {
        try {
            val intent = Intent(Intent.ACTION_ATTACH_DATA)
            intent.addCategory(Intent.CATEGORY_DEFAULT)
            intent.setDataAndType(uri, "image/*")
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
            intent.putExtra("mimeType", "image/*")
            startActivity(Intent.createChooser(intent, "Set Wallpaper As"))
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
