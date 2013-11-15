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
chdir('generated');
//print_r($args);
define('FILE_PATH', $args['file']);
$fileContent = file_get_contents(FILE_PATH);
// $contents[1] -- all contents I should put into edited class
preg_match('/class\s+[^\{]+\{(.+)\}\s*$/ius', $fileContent, $contents);
$bindingsContent = $contents[1];
// $bindings[1] - binding name
// $bindings[2] - new name of the original property, _56786578property
preg_match_all('/function\s+get\s+([^\(\s]+)[^\{]+\{\s*return\s+[^;]+?([^\.;]+);/ius', $bindingsContent, $bindings);
/*
1. find class to apply this bindings
2. look for var name, if it is, apply
3. if not var, look for get/set property
4. save result and delete *-binding file
*/
// getting list of directories in current source folder
$packages = array('.');
$currentDir ='./*';
while(($layer = glob($currentDir, GLOB_ONLYDIR | GLOB_MARK))){
	$currentDir .= '/*';
	if(!$packages){
		$packages = $layer;
	}else{
		$packages = array_merge($packages, $layer);
	}
}
// looking through folders to find class
$fileName = pathinfo(FILE_PATH, PATHINFO_FILENAME);
$fileName = substr($fileName, 1, strlen($fileName)-9);
$index = 0;
while(!($layer = glob($packages[$index].$fileName.'.[aA][sS]'))){
	$index++;
}
if(!$layer || !isset($layer[0]) || !file_exists($layer[0]) || !is_file($layer[0])) die('Can\'t find class "'.$fileName.'" to apply bindings.');
// replace class contents
$classPath = $layer[0];
$classContent = file_get_contents($classPath);
//print_r($bindings);
foreach($bindings[1] as $index=>$bindingName){
	$propertyName = $bindings[2][$index];
	// find and update property definition($bindingName) to new name($propertyName)
}
// add bindings
/*
$packageIndex = strrpos($classContent, '}');
$classIndex = strrpos($classContent, '}', $packageIndex-strlen($classContent)-1);
$classContent = substr($classContent, 0, $classIndex).$bindingsContent."\r\n".substr($classContent, $classIndex);
*/
file_put_contents($classPath, $classContent);
//unlink(FILE_PATH);
?>