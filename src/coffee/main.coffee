# WARNING: this is quick'n'dirty code. You've been warned.
# TODO: Refactor, organize, make it cleaner.

"use strict"

pkg = require "./package.json"

sOSName = require( "os-name" )().toLowerCase().split( " " ).join ""

$ = require "jquery"

oFile = null
oTasks = {}
bTaskRunning = no
iTasksToRun = 0

fFilesSelected = ( e ) ->
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
    fLoadTasks aTasksToLoad if aTasksToLoad.length

fLoadTasks = ( aGivenTasks ) ->
    oTasks = {}
    for sTask in aGivenTasks
        oTasks[ sTask ] = ( oTask = require "./js/tasks/#{ sTask }.js" )
        $task = $ "<li><span><a href=\"#\" class=\"select\">#{ oTask.infos.name }</a></span></li>"
            .attr "id", sTask
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
            .on "click", fSelectTask
            .end()
        .find "li a.config"
            .on "click", fToggleConfig

fSelectTask = ( e ) ->
    e.preventDefault()
    $ this
        .parents "li"
        .toggleClass "selected"

fToggleConfig = ( e ) ->
    e.preventDefault()
    $ this
        .parents "li"
        .toggleClass "open"

fRunTasks = ( e ) ->
    e.preventDefault()
    return if bTaskRunning
    return unless iTasksToRun = ( $tasks = $( "#tasks li.selected" ) ).size()
    ( $reports = $ "div.right > ol" )
        .find "li"
            .removeClass "open"
            .addClass "closed"
    $reports.addClass "loading"
    bTaskRunning = yes
    ( $report = $ "<li />" )
        .addClass "open"
        .appendTo $reports
    ( $link = $ "<a />" )
        .attr "href", "#"
        .appendTo $report
        .on "click", ( e ) ->
            e.preventDefault()
            $( this )
                .parent()
                    .toggleClass "open"
                    .toggleClass "closed"
    $ "<strong />"
        .text oFile.path
        .appendTo $link
    $ "<em />"
        .text "#{ iTasksToRun } task" + ( if iTasksToRun > 1 then "s" else "" )
        .appendTo $link
    ( dDate = new Date() )
    sHours = if ( iHours = dDate.getHours() ) < 10 then "0#{ iHours }" else iHours
    sMinutes = if ( iMinutes = dDate.getMinutes() ) < 10 then "0#{ iMinutes }" else iMinutes
    sSeconds = if ( iSeconds = dDate.getSeconds() ) < 10 then "0#{ iSeconds }" else iSeconds
    $ "<span />"
        .text "#{ sHours }:#{ sMinutes }:#{ sSeconds }"
        .appendTo $link
    $ "<ol />"
        .appendTo $report
    $tasks.each ->
        sID = $( this ).attr "id"
        if ( $config = $( this ).find( "form" ) ).size()
            aConfig = $config.serializeArray()
            oTasks[ sID ].run oFile, aConfig, fDisplayResults
        else
            oTasks[ sID ].run oFile, fDisplayResults

fDisplayResults = ( $results ) ->
    ( $report = $ "div.right > ol" )
        .children "li"
            .last()
                .children "ol"
                    .append $results
    if --iTasksToRun is 0
        bTaskRunning = no
        $report.removeClass "loading"

$ ->
    $ "body"
        .addClass sOSName

    $ "#files a"
        .on "click", ( e ) ->
            e.preventDefault()
            $( "#files input" ).trigger "click"

    $ "#files input"
        .on "change", fFilesSelected

    $ "#tasks .actions a"
        .on "click", fRunTasks

    # require( "nw.gui" ).Window.get().showDevTools() # show console
