group = "jobspls"
version = "0.0.1"

plugins {
    id("org.jetbrains.kotlin.jvm") version "1.9.0"
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
}

tasks.named<Test>("test") {
    useJunitPlatform()
}
