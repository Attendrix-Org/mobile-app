package com.attendrix.app.widget.core

import android.content.Context
import android.content.Intent
import android.net.Uri
import com.attendrix.app.MainActivity

object WidgetActionHelper {
    fun createDeepLinkIntent(context: Context, path: String): Intent {
        val uri = Uri.parse("attendrix://attendrix.app/$path")
        return Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = uri
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
    }
}
