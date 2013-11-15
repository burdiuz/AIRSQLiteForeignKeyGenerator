<?php 
/*
 * [0] -- self PHP script path
 * [1] -- AS file path that should be edited
	$f = fopen('filesetlog.txt', 'a+');
	if(is_resource($f)){
		fwrite($f, print_r($argv, true)."\r\n");
		fclose($f);
	}else die('fopen() didn\'t returned resource:'.$f);
	
Array
(
    [0] => z:\home\localhost\www\tests\TestAIRCompoiler/embeds_replacement.php
    [1] => _TestAIRCompoiler_Styles.as
)
*/
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
if($args['assetsDir'] && !file_exists($args['assetsDir'])) mkdir($args['assetsDir']);
define('ASSETS_PATH', strtr(isset($args['assetsDir']) && $args['assetsDir'] ? realpath($args['assetsDir']) : getcwd().'/generated_assets', '\\', '/'));
define('SOURCES_PATH', strtr(realpath($args['sourceDir']), '\\', '/'));
$allowedParams = array(
	'source'=>true, 
	'mimeType'=>true, 
	'symbol'=>true, 
	'scaleGridTop'=>true, 
	'scaleGridBottom'=>true, 
	'scaleGridLeft'=>true, 
	'scaleGridRight'=>true, 
	'fontWeight'=>true, 
	'fontStyle'=>true, 
	'fontName'=>true, 
	'advancedAntiAliasing'=>true, 
	'fontAntiAliasType'=>true, 
	'fontGridFitType'=>true, 
	'fontSharpness'=>true, 
	'fontThickness'=>true, 
	'unicodeRange'=>true
);

$fileContent = file_get_contents(FILE_PATH);
preg_match_all('/\[Embed\(([^\(]+)\)\]/iu', $fileContent, $embeds);
//print_r($embeds);
echo 'File: '.FILE_PATH."\r\n";
if(isset($embeds[1])){
	foreach($embeds[1] as $embedIndex=>$embedContent){
		preg_match_all('/([_\w]+)\s*=\s*("([^"]*)"|\'([^\']*)\'|`([^`]*)`)/iu', $embedContent, $rawParams);
		if(!isset($rawParams[1])) continue;
		$params = array();
		foreach($rawParams[1] as $paramIndex=>$paramName){
			if(!isset($allowedParams[$paramName])) continue;
			$paramValue = stripcslashes($rawParams[3][$paramIndex]);
			if(!$paramValue) $paramValue = stripcslashes($rawParams[4][$paramIndex]);
			if(!$paramValue) $paramValue = stripcslashes($rawParams[5][$paramIndex]);
			$params[$paramName] = $paramValue;
		}
		//print_r($params);
		if(isset($params['source'])){
			$srcDir = SOURCES_PATH.'/'.pathinfo(FILE_PATH, PATHINFO_DIRNAME);
			$source = $params['source'];
			echo 'Asset: '.$source."\r\n";
			$index = stripos($source, '.swc$');
			if($index===false){
				$source = realpath(file_exists($source) ? $source : $srcDir.'/'.$source);
				$destination = ASSETS_PATH.'/'.strtr($source, "\\/|: \t", '______');
				echo ' - copy to: '.$destination."\r\n";
				copy($source, $destination);
				$params['source'] = $destination;
			}else{
				$swcPath = substr($source, 0, $index+4);
				$swcPath = realpath(file_exists($swcPath) ? $swcPath : $srcDir.'/'.$swcPath);
				if(!$swcPath) die('Assets SWC not found: '.substr($source, 0, $index+4));
				$assetsDirPath = ASSETS_PATH.'/'.strtr($swcPath, "\\/|: \t", '______').'/';
				if(!file_exists($assetsDirPath)){
					echo ' - extract to: '.$assetsDirPath."\r\n";
					$swcZip = new ZipArchive();
					if($swcZip->open($swcPath)){
						$swcZip->extractTo($assetsDirPath);
						$swcZip->close();
					}else die("Not able to open SWC to extract.");
				}
				$params['source'] = $assetsDirPath.substr($source, $index+5);
			}
		}
		$listParams = array();
		foreach($params as $paramName=>$paramValue){
			$listParams[] = $paramName.'="'.$paramValue.'"';
		}
		$newEmbed = '[Embed('.implode(', ', $listParams).')]';
		echo $newEmbed."\r\n";
		$fileContent = str_replace($embeds[0][$embedIndex], $newEmbed, $fileContent);
	}
}
file_put_contents(FILE_PATH, $fileContent);
?>