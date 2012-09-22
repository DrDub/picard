# vim:set ft=coffee ts=4 sw=4 sts=4 autoindent: encoding=utf-8:

# Picard - a visualiser and navigator for word representations (spaces)
#
# Author:   Pontus Stenetorp    <pontus stenetorp se>
# Version:  2012-09-22

$ = jQuery

# TODO: These should not be hard-coded
BORDER = 50
WIDTH = 1024
HEIGHT = 768

class Picard
    constructor: (anchor_xpath, file_xpath) ->
        @anchor_elem = $ anchor_xpath
        @file_elem = $ file_xpath
        # Attach our file change logic
        @file_elem.change (evt) => @on_file_change evt

    run: ->
        @anchor_elem.svg onLoad: => do @on_load

    on_load: ->
        @svg = @anchor_elem.svg 'get'

    on_file_change: (evt) ->
        oevt = evt.originalEvent
        file = oevt.target.files[0]

        reader = new FileReader
        reader.onload = (evt) => @on_file_read evt
        reader.readAsText file

    on_file_read: (evt) ->
        # TODO: Extend to support more formats
        lbl_space = {}
        for line in evt.target.result.split '\n' when line
            soup = line.split '\t'
            lbl = soup[0]
            lbl_pos = (parseFloat val for val, i in soup when i > 0)
            lbl_space[lbl] = lbl_pos
        @visualise lbl_space

    visualise: (lbl_space) ->
        for lbl, lbl_pos of lbl_space
            x_pos = BORDER + lbl_pos[0] * (WIDTH - BORDER)
            y_pos = BORDER + lbl_pos[1] * (HEIGHT - BORDER)
            @svg.text x_pos, y_pos, lbl

# Export to the global namespace
root = exports ? this
root.Picard = Picard
