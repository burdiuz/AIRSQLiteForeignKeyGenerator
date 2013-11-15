<?php
$args = array();
$argName = 'phpSelf';
for($index=1; $index<count($argv); $index++){
	if($argv[$index][0]=='-'){
		$argName = substr($argv[$index], 1);
		$args[$argName] = true;
	}else{
		$args[$argName] = $argv[$index];
	}
}
//print_r($args);
define('FILE_PATH', $args['file']);
$fileName = pathinfo(FILE_PATH, PATHINFO_FILENAME);
$fileContent = file_get_contents(FILE_PATH);
preg_match('/class\s+([^\s\{]+)/iu', $fileContent, $matches);
if(isset($matches[1]) && $matches[1]!=$fileName){
	rename(FILE_PATH, pathinfo(FILE_PATH, PATHINFO_DIRNAME).'/'.$matches[1].'.as');
}
?>