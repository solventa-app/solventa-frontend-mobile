import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Firmado por ambiente. El CI escribe estos archivos desde los secretos (tool/firma.sh); en tu máquina no
// existen y el build de release se firma con la llave de debug, para que `flutter run --release` funcione.
fun propiedades(nombre: String) = Properties().apply {
    val f = rootProject.file(nombre)
    if (f.exists()) f.inputStream().use { load(it) }
}
val firmas = mapOf("dev" to propiedades("key-dev.properties"), "prod" to propiedades("key.properties"))

android {
    namespace = "com.solventa.solventa_mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.solventa.solventa_mobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    signingConfigs {
        firmas.forEach { (ambiente, props) ->
            if (props.isNotEmpty()) {
                create(ambiente) {
                    keyAlias = props["keyAlias"] as String
                    keyPassword = props["keyPassword"] as String
                    storeFile = file(props["storeFile"] as String)
                    storePassword = props["storePassword"] as String
                }
            }
        }
    }

    // Llave del ambiente si el CI la dejó; si no, la de debug. Aplica a release: el tipo debug siempre usa la de debug.
    fun firma(ambiente: String) = signingConfigs.findByName(ambiente) ?: signingConfigs.getByName("debug")

    // Dos apps distintas en el teléfono: datos, SQLite, almacenamiento seguro y sesión nunca se mezclan.
    // La configuración de Dart de cada una está en config/<flavor>.json (docs/ci-cd.md, "Ambientes dev y prod").
    flavorDimensions += "ambiente"
    productFlavors {
        create("dev") {
            dimension = "ambiente"
            applicationIdSuffix = ".dev"
            signingConfig = firma("dev")
            manifestPlaceholders["appName"] = "Solventa Dev"
            // Permite http hacia el gateway local (10.0.2.2:8080).
            manifestPlaceholders["usesCleartextTraffic"] = "true"
        }
        create("prod") {
            dimension = "ambiente"
            signingConfig = firma("prod")
            manifestPlaceholders["appName"] = "Solventa"
            manifestPlaceholders["usesCleartextTraffic"] = "false"
        }
    }

    buildTypes {
        release {
            // R8: encoge, ofusca y optimiza el código Java/Kotlin y quita recursos sin uso. Flutter ya lo activa
            // por defecto en release; se deja explícito. La ofuscación del código Dart (--obfuscate) es aparte y
            // solo en prod (docs/ci-cd.md, "R8, ofuscación y símbolos").
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

dependencies {
    // Corre integration_test/ en Firebase Test Lab (android/app/src/androidTest/).
    androidTestImplementation("androidx.test:runner:1.6.2")
    androidTestImplementation("androidx.test:rules:1.6.1")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.6.1")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
