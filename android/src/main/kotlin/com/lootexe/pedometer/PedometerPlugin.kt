package com.lootexe.pedometer

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel

/** PedometerPlugin */
class PedometerPlugin: FlutterPlugin {
  private lateinit var eventChannel: EventChannel
  private lateinit var sensorHandler: SensorHandler

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    sensorHandler = SensorHandler(flutterPluginBinding.applicationContext)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger,
      "com.lootexe.pedometer.event")

    eventChannel.setStreamHandler(sensorHandler)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    eventChannel.setStreamHandler(null)
  }
}
