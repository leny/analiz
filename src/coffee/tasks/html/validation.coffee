# build on top of w3cjs

"use strict"

w3cjs = require "w3cjs"
$ = require "jquery"

exports.infos = oInfos =
    name: "W3C Validator"
    config: no

exports.run = ( oFile, fNext ) ->
    w3cjs.validate
        file: oFile.path
        callback: ( oResponse ) ->
            # TODO : error managment
            $report = $ "<li />"
            $ "<strong />"
                .text oInfos.name
                .appendTo $report
            ( $container = $ "<div />" )
                .addClass "result"
                .appendTo $report
            if oResponse.messages && oResponse.messages.length
                ( $counter = $ "<span />" )
                    .text "#{ oResponse.messages.length } message" + ( if oResponse.messages.length > 1 then "s" else "" )
                    .appendTo $container
                ( $list = $ "<ol />" )
                    .appendTo $container
                for oMessage in oResponse.messages
                    ( $message = $ "<li />" )
                        .addClass "message"
                        .addClass oMessage.type or oMessage.subtype
                        .appendTo $list
                    $ "<strong />"
                        .text oMessage.type or oMessage.subtype
                        .appendTo $message
                    $ "<em />"
                        .addClass "line"
                        .text oMessage.lastLine
                        .appendTo $message
                    $ "<span />"
                        .text oMessage.message
                        .appendTo $message
            else
                $ "<span />"
                    .addClass "no-message"
                    .text "no error"
                    .appendTo $container
            fNext $report
