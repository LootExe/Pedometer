package com.lootexe.pedometer

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import org.json.JSONException
import org.json.JSONObject

class SensorHandler(context: Context,
                    messenger: BinaryMessenger): EventChannel.StreamHandler {
    private val eventChannel: EventChannel
    private val sensorManager: SensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private var sensor: Sensor? = null
    private var sensorListener: SensorEventListener? = null

    init {
        eventChannel = EventChannel(messenger,
            "com.lootexe.pedometer.sensor", JSONMethodCodec.INSTANCE)
        eventChannel.setStreamHandler(this)

        sensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        if (arguments == null) {
            events.error("-1","No arguments specified", "")
            return
        }

        var config: SensorConfiguration? = null

        try {
           config = SensorConfiguration.fromJson(arguments as JSONObject)
        }
        catch (e: JSONException) {
            events.error("-1","error", "JSON error: " + e.message)
        }

        if (config == null) {
            return
        }

        if (sensor == null) {
            events.error("-1","Sensor not available",
                "No pedometer hardware found on this device")
            return
        }

        sensorListener = object : SensorEventListener {
            override fun onSensorChanged(p0: SensorEvent?) {
                if (p0 == null) {
                    return
                }

                val json = JSONObject().apply {
                    put("stepCount", p0.values[0].toInt())
                }

                events.success(json)
            }

            override fun onAccuracyChanged(p0: Sensor?, p1: Int) {}
        }

        sensorManager.registerListener(
            sensorListener,
            sensor,
            SensorManager.SENSOR_DELAY_NORMAL,
            config.batchingInterval)
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(sensorListener)
    }

    fun dispose() {
        eventChannel.setStreamHandler(null)
    }
}