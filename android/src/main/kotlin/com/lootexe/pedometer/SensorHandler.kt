package com.lootexe.pedometer

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel

class SensorHandler(context: Context) : EventChannel.StreamHandler {
    private var sensorManager: SensorManager
    private var sensor: Sensor? = null
    private var sensorListener: StepSensorListener? = null

    init {
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        sensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
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