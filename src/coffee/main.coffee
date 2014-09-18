"use strict"

global.$ = $

pkg = require "./package.json"

sOSName = require( "os-name" )().toLowerCase().split( " " ).join ""

fs = require "fs"
path = require "path"

$ ->
    console.log "analiz:started"

    $( "body" ).addClass sOSName

    require( "nw.gui" ).Window.get().showDevTools()
