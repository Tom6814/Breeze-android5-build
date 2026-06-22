import groovy.json.JsonSlurper
import java.util.Properties
import java.io.File

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

repositories {
    maven {
        url = uri(findRustlsPlatformVerifierProject())
        metadataSources {
            artifact()
            mavenPom()
        }
    }
}

fun findRustlsPlatformVerifierProject(): String {
    val dependencyText = providers.exec {
        workingDir = File(project.rootDir, "../")
        commandLine(
            "cargo",
            "metadata",
            "--format-version",
            "1",
            "--filter-platform",
            "aarch64-linux-android",
            "--manifest-path",
            "rust/Cargo.toml",
        )
    }.standardOutput.asText.get()

    val dependencyJson = JsonSlurper().parseText(dependencyText) as Map<*, *>
    val packages = dependencyJson["packages"] as List<*>
    val manifestPath = packages
        .mapNotNull { it as? Map<*, *> }
        .first { it["name"] == "rustls-platform-verifier-android" }["manifest_path"] as String

    return File(File(manifestPath).parentFile, "maven").path
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.zephyr.breeze"
    compileSdk = 36
    ndkVersion = "29.0.14206865"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    java {
        toolchain {
            languageVersion.set(JavaLanguageVersion.of(17))
        }
    }

    defaultConfig {
        // Keep Android 5 (API 21) support while avoiding Flutter's auto-migrator,
        // which rewrites literal values 16-23 to flutter.minSdkVersion (24).
        minSdk = 21 + 0
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { project.file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs["release"]
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

configurations.all {
    resolutionStrategy {
        // Some transitive AndroidX upgrades now require minSdk 23.
        // Keep core/core-ktx on the last API 21-compatible line for Android 5 builds.
        force("androidx.core:core:1.16.0")
        force("androidx.core:core-ktx:1.16.0")
    }
}

dependencies {
    // 添加核心库脱糖依赖
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("rustls:rustls-platform-verifier:0.1.1")
}
