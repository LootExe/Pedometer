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
        val config = parseConfiguration(arguments)

        if (config == null) {
            events.error("-1","Config parse error",
                "Couldn't parse sensor configuration json")
            return
        }

        if (sensor == null) {
            events.error("-1","Sensor not available",
                "No pedometer hardware found on this device")
            return
        }

        sensorListener = object : SensorEventListener {
            override fun onSensorChanged(sensorEvent: SensorEvent?) {
                sensorEvent ?: return

                sensorEvent.values.firstOrNull()?.let {
                    val json = JSONObject().apply {
                        put("stepCount", it.toInt())
                    }

                    events.success(json)
                }
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

    private fun parseConfiguration(arguments: Any?): SensorConfiguration? {
        arguments ?: return null

        return try {
            SensorConfiguration.fromJson(arguments as JSONObject)
        } catch (e: JSONException) {
            null
        }
    }

    fun dispose() {
        eventChannel.setStreamHandler(null)
    }
}