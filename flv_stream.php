<?php
session_cache_limiter('nocache');
header('Expires: Thu, 19 Nov 1981 08:52:00 GMT');
header('Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0');
header('Pragma: no-cache');
	
$position = $_GET['position'];
$filename = dirname(__FILE__).'/'.htmlspecialchars($_GET['file']);


if (file_exists($filename)) {
	header('Content-Type: video/x-flv');
	if ($position != 0) {
		echo 'FLV', pack('CCNN', 1, 1, 9, 9);
	}
	$file = fopen($filename, "rb");
	fseek($file, $position);
	while (!feof($file)) {
		echo fread($file, 16384);
	}
	fclose($file);
} else {
	echo 'The file does not exist';
}
?>