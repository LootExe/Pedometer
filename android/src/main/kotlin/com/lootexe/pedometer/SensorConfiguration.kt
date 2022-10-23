package com.lootexe.pedometer

import org.json.JSONObject

data class SensorConfiguration(val batchingInterval: Int) {
    companion object {
        fun fromJson(json: JSONObject): SensorConfiguration {
            val interval = json.getInt("batching")

            return SensorConfiguration(interval)
        }
    }
}