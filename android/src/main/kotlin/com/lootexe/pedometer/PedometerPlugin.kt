package com.lootexe.pedometer

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** PedometerPlugin */
class PedometerPlugin: FlutterPlugin, MethodChannel.MethodCallHandler {
  private lateinit var methodChannel: MethodChannel
  private var sensorHandler: SensorHandler? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(
      binding.binaryMessenger,
      "com.lootexe.pedometer.method",
      JSONMethodCodec.INSTANCE
    )

    methodChannel.setMethodCallHandler(this)
    sensorHandler = SensorHandler(binding.applicationContext, binding.binaryMessenger)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    sensorHandler?.dispose()
    sensorHandler = null
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "registerSensor" -> sensorHandler?.registerSensor(call.arguments, result)
      "unregisterSensor" -> {
        sensorHandler?.unregisterSensor()
        result.success(true)
      }
      "isRegistered" -> result.success(sensorHandler?.isRegistered)
      "stepCount" -> result.success(sensorHandler?.stepCount)
      else -> result.notImplemented()
    }
  }
}
