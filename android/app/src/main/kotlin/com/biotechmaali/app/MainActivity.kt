package com.biotechmaali.app

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileOutputStream

class MainActivity: FlutterActivity(), MethodCallHandler {
    private val CHANNEL = "native_photo_picker"
    private var pendingResult: Result? = null
    private var photoUri: Uri? = null
    
    companion object {
        private const val REQUEST_PICK_IMAGE = 1001
        private const val REQUEST_PICK_MULTIPLE_IMAGES = 1002
        private const val REQUEST_TAKE_PHOTO = 1003
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (pendingResult != null) {
            result.error("ALREADY_ACTIVE", "Photo picker is already active", null)
            return
        }
        
        pendingResult = result
        
        when (call.method) {
            "pickImage" -> pickSingleImage()
            "pickMultipleImages" -> pickMultipleImages()
            "takePhoto" -> takePhoto()
            else -> {
                pendingResult = null
                result.notImplemented()
            }
        }
    }
    
    private fun pickSingleImage() {
        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            // Use Android 13+ Photo Picker API (no permissions needed)
            Intent(MediaStore.ACTION_PICK_IMAGES).apply {
                type = "image/*"
            }
        } else {
            // Fallback for older Android versions
            Intent(Intent.ACTION_PICK).apply {
                type = "image/*"
            }
        }
        
        startActivityForResult(intent, REQUEST_PICK_IMAGE)
    }
    
    private fun pickMultipleImages() {
        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            // Use Android 13+ Photo Picker API (no permissions needed)
            Intent(MediaStore.ACTION_PICK_IMAGES).apply {
                type = "image/*"
                putExtra(MediaStore.EXTRA_PICK_IMAGES_MAX, 10) // Max 10 images
            }
        } else {
            // Fallback for older Android versions
            Intent(Intent.ACTION_PICK).apply {
                type = "image/*"
                putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
            }
        }
        
        startActivityForResult(intent, REQUEST_PICK_MULTIPLE_IMAGES)
    }
    
    private fun takePhoto() {
        // Create a temporary file for the photo
        val tempDir = File(cacheDir, "photos")
        if (!tempDir.exists()) {
            tempDir.mkdirs()
        }
        
        val photoFile = File(tempDir, "photo_${System.currentTimeMillis()}.jpg")
        photoUri = androidx.core.content.FileProvider.getUriForFile(
            this,
            "${packageName}.fileprovider",
            photoFile
        )
        
        val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE).apply {
            putExtra(MediaStore.EXTRA_OUTPUT, photoUri)
        }
        
        startActivityForResult(intent, REQUEST_TAKE_PHOTO)
    }
    
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        
        when (requestCode) {
            REQUEST_PICK_IMAGE -> {
                if (resultCode == Activity.RESULT_OK) {
                    val uri = data?.data
                    if (uri != null) {
                        val imagePath = copyImageToTempFile(uri)
                        pendingResult?.success(imagePath)
                    } else {
                        pendingResult?.error("NO_IMAGE", "No image selected", null)
                    }
                } else {
                    pendingResult?.error("CANCELLED", "User cancelled image selection", null)
                }
                pendingResult = null
            }
            
            REQUEST_PICK_MULTIPLE_IMAGES -> {
                if (resultCode == Activity.RESULT_OK) {
                    val imagePaths = mutableListOf<String>()
                    
                    data?.clipData?.let { clipData ->
                        // Multiple images selected
                        for (i in 0 until clipData.itemCount) {
                            val uri = clipData.getItemAt(i).uri
                            val imagePath = copyImageToTempFile(uri)
                            if (imagePath != null) {
                                imagePaths.add(imagePath)
                            }
                        }
                    } ?: data?.data?.let { uri ->
                        // Single image selected
                        val imagePath = copyImageToTempFile(uri)
                        if (imagePath != null) {
                            imagePaths.add(imagePath)
                        }
                    }
                    
                    pendingResult?.success(imagePaths)
                } else {
                    pendingResult?.error("CANCELLED", "User cancelled image selection", null)
                }
                pendingResult = null
            }
            
            REQUEST_TAKE_PHOTO -> {
                if (resultCode == Activity.RESULT_OK) {
                    photoUri?.let { uri ->
                        val imagePath = copyImageToTempFile(uri)
                        pendingResult?.success(imagePath)
                    } ?: run {
                        pendingResult?.error("NO_IMAGE", "Failed to capture photo", null)
                    }
                } else {
                    pendingResult?.error("CANCELLED", "User cancelled photo capture", null)
                }
                pendingResult = null
            }
        }
    }
    
    private fun copyImageToTempFile(uri: Uri): String? {
        try {
            val tempDir = File(cacheDir, "selected_images")
            if (!tempDir.exists()) {
                tempDir.mkdirs()
            }
            
            val tempFile = File(tempDir, "image_${System.currentTimeMillis()}.jpg")
            
            contentResolver.openInputStream(uri)?.use { inputStream ->
                FileOutputStream(tempFile).use { outputStream ->
                    inputStream.copyTo(outputStream)
                }
            }
            
            return tempFile.absolutePath
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }
}