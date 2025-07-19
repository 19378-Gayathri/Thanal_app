plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ Firebase plugin
}

android {
    namespace = "com.example.thanal_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.thanal_app"
        minSdk = 21 // ✅ Required for Firebase & speech_to_text
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true // ✅ Needed for Dialogflow or large method count
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // You can change to release signing later
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase BOM to manage versions
    implementation(platform("com.google.firebase:firebase-bom:33.15.0"))

    // ✅ Required Firebase libraries (add more as needed)
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-firestore")
}
