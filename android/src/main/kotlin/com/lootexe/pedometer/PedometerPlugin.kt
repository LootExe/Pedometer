package com.lootexe.pedometer

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/** PedometerPlugin */
class PedometerPlugin: FlutterPlugin {
  private lateinit var methodChannel : MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var sensorHandler: SensorHandler

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    sensorHandler = SensorHandler(flutterPluginBinding.applicationContext)

    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger,
      "com.lootexe.pedometer")
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger,
      "com.lootexe.pedometer.event")

    methodChannel.setMethodCallHandler(sensorHandler)
    eventChannel.setStreamHandler(sensorHandler)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }
}
