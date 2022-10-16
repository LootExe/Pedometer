package com.lootexe.pedometer

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SensorHandler(context: Context) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private var sensorManager: SensorManager
    private var sensor: Sensor? = null
    private var sensorListener: StepSensorListener? = null
    private var stepCount = 0

    init {
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        sensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            // TODO: Remove later
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "getStepCount" -> result.success(stepCount)
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        if (sensor == null) {
            events.error("-1", "Sensor not available",
                "No pedometer hardware found on this device")
        } else {
            // Prevent multiple listener registrations
            if (sensorListener != null) {
                return
            }

            sensorListener = StepSensorListener { data: Int ->
                events.success(data)
                stepCount = data
            }

            sensorManager.registerListener(
                sensorListener, sensor, SensorManager.SENSOR_DELAY_FASTEST)
        }
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(sensorListener)
        sensorListener = null
    }
}