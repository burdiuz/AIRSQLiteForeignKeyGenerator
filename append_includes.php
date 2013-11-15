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
define('TEMPLATE_INCLUDES_MARK', '{includes}');
$includes = explode(" ", trim($args['includes']));
foreach($includes as $index=>$include){
	$includes[$index] = '<includes symbol="'.$include.'"/>';
}
//print_r($includes);
$fileContent = file_get_contents(FILE_PATH);
$fileContent = str_replace(TEMPLATE_INCLUDES_MARK, implode("\r\n", $includes), $fileContent);
file_put_contents(FILE_PATH, $fileContent);
?>