# WARNING: this is quick'n'dirty code. You've been warned.

"use strict"

pkg = require "./package.json"

sOSName = require( "os-name" )().toLowerCase().split( " " ).join ""

fs = require "fs"
path = require "path"

oFile = null
aTasks = []

filesSelected = ( e ) ->
    return unless oFile = e.originalEvent.target.files[ 0 ]
    $ "#tasks ol"
        .empty()
        .toggleClass "loading", yes
    $ "#files a"
        .toggleClass "loaded", yes
        .text oFile.name
    switch oFile.type
        when "text/html"
            aTasksToLoad = [
                "html/validation"
                "html/lint"
            ]
        else
            console.log "no tasks for that kind of files."
    loadTasks aTasksToLoad if aTasksToLoad.length

loadTasks = ( aGivenTasks ) ->
    aTasks = []
    for sTask in aGivenTasks
        oTask = require "./js/tasks/#{ sTask }.js"
        aTasks.push oTask
        $task = $ "<li><span><a href=\"#\" class=\"select\">#{ oTask.infos.name }</a></span></li>"
        $ "#tasks ol"
            .append $task
        if oTask.infos.config and oTask.config
            $ "<a />"
                .addClass "config"
                .attr "href", "#"
                .attr "title", "edit configuration"
                .appendTo $task.find "span"
            $taskConfigForm = $ "<form />"
            for sLegend, oFieldsets of oTask.config
                $fieldset = $ "<fieldset><legend>#{ sLegend }</legend></fieldset>"
                for sName, oFieldInfo of oFieldsets
                    $element = $ "<div />"
                        .addClass "form-elt"
                    if oFieldInfo.radio
                        $element
                            .addClass "multiple"
                        $ "<strong />"
                            .text oFieldInfo.title
                            .appendTo $element
                        for oRadioInfo in oFieldInfo.values
                            $label = $ "<label />"
                                .appendTo $element
                            $ "<input />"
                                .attr "type", "radio"
                                .attr "name", sName
                                .attr "value", oRadioInfo.value
                                .prop "checked", !!oRadioInfo.checked
                                .appendTo $label
                            $ "<span />"
                                .text oRadioInfo.title
                                .appendTo $label
                            $ "<p />"
                                .text oRadioInfo.description
                                .appendTo $label
                    else
                        $label = $ "<label />"
                            .appendTo $element
                        $ "<input />"
                            .attr "type", "checkbox"
                            .attr "name", sName
                            .attr "value", oFieldInfo.value
                            .prop "checked", !!oFieldInfo.checked
                            .appendTo $label
                        $ "<span />"
                            .text oFieldInfo.title
                            .appendTo $label
                        $ "<p />"
                            .text oFieldInfo.description
                            .appendTo $label
                    $element.appendTo $fieldset
                $fieldset.appendTo $taskConfigForm
            $taskConfigForm.appendTo $task
    $ "#tasks ol"
        .toggleClass "loading", no
        .find "li a.select"
            .on "click", selectTask
            .end()
        .find "li a.config"
            .on "click", toggleConfig

selectTask = ( e ) ->
    e.preventDefault()
    $ this
        .parent()
        .toggleClass "selected"

toggleConfig = ( e ) ->
    e.preventDefault()
    $ this
        .parents "li"
        .toggleClass "open"

$ ->
    $ "body"
        .addClass sOSName

    $ "#files a"
        .on "click", ( e ) ->
            e.preventDefault()
            $( "#files input" ).trigger "click"

    $ "#files input"
        .on "change", filesSelected

    require( "nw.gui" ).Window.get().showDevTools()
