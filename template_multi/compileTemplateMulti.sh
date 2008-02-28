#!/bin/bash

cp ../base/player.swf player_flv_multi.swf
../mtasc/mtasc -version 8 -keep -v -main -cp ../classes -swf player_flv_multi.swf TemplateMulti.as

