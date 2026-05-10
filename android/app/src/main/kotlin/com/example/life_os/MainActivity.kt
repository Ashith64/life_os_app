package com.example.life_os

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Process
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.lifeos.app/usage_stats"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkUsagePermission" -> {
                    result.success(hasUsageStatsPermission())
                }
                "requestUsagePermission" -> {
                    startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
                    result.success(null)
                }
                "getUsageStats" -> {
                    if (!hasUsageStatsPermission()) {
                        result.error("PERMISSION_DENIED", "Usage access permission not granted", null)
                        return@setMethodCallHandler
                    }

                    val startTime = call.argument<Long>("startTime") ?: 0L
                    val endTime = call.argument<Long>("endTime") ?: System.currentTimeMillis()

                    val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
                    val queryUsageStats = usageStatsManager.queryUsageStats(
                        UsageStatsManager.INTERVAL_DAILY,
                        startTime,
                        endTime
                    )

                    val appUsageMap = HashMap<String, Long>()
                    for (usageStats in queryUsageStats) {
                        val totalTime = usageStats.totalTimeInForeground
                        if (totalTime > 0) {
                            // Sum up usage for identical packages (in case of multiple events)
                            val existingTime = appUsageMap[usageStats.packageName] ?: 0L
                            appUsageMap[usageStats.packageName] = existingTime + totalTime
                        }
                    }
                    result.success(appUsageMap)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun hasUsageStatsPermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(), packageName
            )
        } else {
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(), packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }
}
