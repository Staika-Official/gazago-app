import android.content.Context
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.core.location.LocationManagerCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class GpsPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "gps_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getGpsAccuracy") {
            val gpsAccuracy = getGpsAccuracy()
            result.success(gpsAccuracy)
        } else {
            result.notImplemented()
        }
    }

    private fun getGpsAccuracy(): Double {
        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return if (locationManager != null && LocationManagerCompat.isLocationEnabled(locationManager)) {
            val locationListener = object : LocationListener {
                override fun onLocationChanged(location: Location) {}
                override fun onProviderDisabled(provider: String) {}
                override fun onProviderEnabled(provider: String) {}
                override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {}
            }
            locationManager.requestSingleUpdate(LocationManager.GPS_PROVIDER, locationListener, null)
            val lastLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
            lastLocation?.accuracy?.toDouble() ?: 0.0
        } else {
            0.0
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        // Cleanup
    }
}
