#!/bin/bash

cp ../base/player.swf player_flv_mini.swf
../mtasc/mtasc -version 7 -keep -strict -v -main -cp ../classes -swf player_flv_mini.swf TemplateMini.as

