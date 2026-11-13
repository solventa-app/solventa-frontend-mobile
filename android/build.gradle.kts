allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// HU-M06 (M0): el plugin de Mapbox solo aplica Kotlin con AGP < 9 y, con AGP 9, cuenta con el Kotlin
// integrado, que aquí está apagado (`android.builtInKotlin=false`, gradle.properties). Sin esto su
// `build.gradle` falla en el bloque `kotlin {}`. Se aplica el plugin de Kotlin solo a ese módulo, en
// cuanto aplica el de librería de Android, sin cambiar la bandera para toda la app.
subprojects {
    if (name == "mapbox_maps_flutter_mobile") {
        pluginManager.withPlugin("com.android.library") {
            pluginManager.apply("org.jetbrains.kotlin.android")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
