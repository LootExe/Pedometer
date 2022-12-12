package com.lootexe.pedometer

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import org.json.JSONObject

class SensorHandler(context: Context,
                    messenger: BinaryMessenger): EventChannel.StreamHandler, SensorEventListener {
    private val eventChannel: EventChannel
    private val sensorManager: SensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private var eventSink: EventChannel.EventSink? = null

    var stepCount: Int = 0
    var isRegistered: Boolean = false

    init {
        eventChannel = EventChannel(messenger,
            "com.lootexe.pedometer.event", JSONMethodCodec.INSTANCE)
        eventChannel.setStreamHandler(this)
    }

    fun registerSensor(arguments: Any?, result: MethodChannel.Result) {
        unregisterSensor()

        val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        val config = parseConfiguration(arguments)

        if (sensor == null) {
            result.error("Sensor error",
                "No pedometer hardware found on this device", null)
            return
        }

        if (config == null) {
            result.error("Config error",
                "Couldn't parse sensor configuration json", null)
            return
        }

        isRegistered = sensorManager.registerListener(
            this,
            sensor,
            config.samplingRate,
            config.batchingInterval)

        result.success(isRegistered)
    }

    fun unregisterSensor() {
        sensorManager.unregisterListener(this)
        isRegistered = false
    }

    fun dispose() {
        unregisterSensor()
        eventChannel.setStreamHandler(null)
        eventSink = null
        stepCount = 0
    }

    override fun onSensorChanged(event: SensorEvent?) {
        event ?: return

        event.values.firstOrNull()?.let {
            stepCount = it.toInt()
            eventSink?.success(JSONObject().apply {
                put("stepCount", stepCount)
            })
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        eventSink = events
        eventSink?.success(JSONObject().apply {
            put("stepCount", stepCount)
        })
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    private fun parseConfiguration(arguments: Any?): SensorConfiguration? {
        arguments ?: return null

        return try {
            SensorConfiguration.fromJson(arguments as JSONObject)
        } catch (e: JSONException) {
            null
        }
    }
}