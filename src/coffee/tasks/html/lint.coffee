# build on top of grunt-htmlhint

"use strict"

exports.infos =
    name: "HTML Hint"
    config: yes

exports.config =
    "Standard":
        "tagname-lowercase":
            title: "Tagname lowercase"
            value: 1
            checked: yes
            description: "Tagname must be lowercase."
        "attr-lowercase":
            title: "Attr lowercase"
            value: 1
            checked: yes
            description: "Attribute name must be lowercase."
        "attr-value-double-quotes":
            title: "Attr value double quotes"
            value: 1
            checked: yes
            description: "Attribute value must closed by double quotes."
        "attr-value-not-empty":
            title: "Attr value not empty"
            value: 1
            description: "Attribute must set value."
        "doctype-first":
            title: "Doctype first"
            value: 1
            description: "Doctype must be first."
        "tag-pair":
            title: "Tag par"
            value: 1
            description: "Tag must be paired"
        "tag-self-close":
            title: "Tag self close"
            value: 1
            description: "The empty tag must be closed by self"
        "spec-char-escape":
            title: "Tag self close"
            value: 1
            description: "Special characters must be escaped."
        "id-unique":
            title: "ID unique"
            value: 1
            description: "Id must be unique."
        "src-not-empty":
            title: "Src not empty"
            value: 1
            description: "Src of img(script,link) must set value.\nEmpty src will visit current page twice."
    "Performance":
        "head-script-disabled":
            title: "Head script disabled"
            value: 1
            description: "The script tag can not be used in head."
    "Accessibility":
        "img-alt-require":
            title: "Img alt require"
            value: 1
            checked: yes
            description: "Alt of img tag must be set value."
    "Specification":
        "doctype-html5":
            title: "Doctype html5"
            value: 1
            description: "Doctype must be html5."
        "id-class-value":
            title: "ID class value"
            radio: yes
            values: [
                    title: "none"
                    value: 0
                    checked: yes
                    description: "Id and class value doesn't need to follow some rules."
                ,
                    title: "underline"
                    value: "underline"
                    description: "Id and class value must meet some rules: underline_separated."
                ,
                    title: "dash"
                    value: "dash"
                    description: "Id and class value must meet some rules: dash-separated."
                ,
                    title: "camelCase"
                    value: "hump"
                    description: "Id and class value must meet some rules: camelCaseSeparated."
            ]
        "style-disabled":
            title: "Style disabled"
            value: 1
            description: "Style tag can not be use."



exports.run = ( grunt ) ->
    console.log "run html hint"
