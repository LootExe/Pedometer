package com.lootexe.pedometer

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel

/** PedometerPlugin */
class PedometerPlugin: FlutterPlugin {
  private lateinit var eventChannel: EventChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger,
      "com.lootexe.pedometer.event")

    val handler = SensorHandler(flutterPluginBinding.applicationContext)
    eventChannel.setStreamHandler(handler)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    eventChannel.setStreamHandler(null)
  }
}
