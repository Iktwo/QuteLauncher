package com.iktwo.qutelauncher

class Application(var name: String, var packageName: String) : Comparable<Application> {

    override fun compareTo(application: Application): Int {
        return this.name.toUpperCase().compareTo(application.name.toUpperCase())
    }
}
