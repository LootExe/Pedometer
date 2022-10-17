package com.lootexe.pedometer

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel

class SensorHandler(context: Context) : EventChannel.StreamHandler, SensorEventListener {
    private var sensorManager: SensorManager
    private var sensor: Sensor? = null
    private var eventSink: EventChannel.EventSink? = null

    init {
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        sensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
    }

    override fun onSensorChanged(p0: SensorEvent?) {
        if (p0 == null || eventSink == null) {
            return
        }

        eventSink?.success(p0.values[0].toInt())
    }

    override fun onAccuracyChanged(p0: Sensor?, p1: Int) {}

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        if (sensor == null) {
            events.error("-1",
                "Sensor not available",
                "No pedometer hardware found on this device")
            return
        }

        eventSink = events
        sensorManager.registerListener(
            this, sensor, SensorManager.SENSOR_DELAY_NORMAL)
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(this)
        eventSink = null
    }
}