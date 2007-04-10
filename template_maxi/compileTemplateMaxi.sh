#!/bin/bash

cp ../base/player.swf player_flv_maxi.swf
../mtasc/mtasc -version 7 -keep -strict -v -main -cp ../classes -swf player_flv_maxi.swf TemplateMaxi.as

