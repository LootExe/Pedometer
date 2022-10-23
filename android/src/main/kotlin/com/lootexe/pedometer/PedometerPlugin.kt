package com.lootexe.pedometer

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** PedometerPlugin */
class PedometerPlugin: FlutterPlugin {
  private var sensorHandler: SensorHandler? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    sensorHandler = SensorHandler(binding.applicationContext, binding.binaryMessenger)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    sensorHandler?.dispose()
    sensorHandler = null
  }
}
