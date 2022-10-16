package com.lootexe.pedometer

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener

class StepSensorListener(onNewData: (value: Int) -> Unit) : SensorEventListener {
    private var onNewData : (value: Int) -> Unit

    init {
        this.onNewData = onNewData
    }

    override fun onSensorChanged(p0: SensorEvent?) {
        if (p0 == null) {
            return
        }

        onNewData(p0.values[0].toInt())
    }

    override fun onAccuracyChanged(p0: Sensor?, p1: Int) {
    }
}