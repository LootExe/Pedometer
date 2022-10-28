package com.lootexe.pedometer

import org.json.JSONObject

data class SensorConfiguration(val samplingRate: Int,
                               val batchingInterval: Int) {
    companion object {
        fun fromJson(json: JSONObject): SensorConfiguration {
            val samplingRate = json.getInt("samplingRate")
            val batching = json.getInt("batchingInterval")

            return SensorConfiguration(samplingRate, batching)
        }
    }
}