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

define('SOURCE', $args['source']);
define('DESTINATION', $args['destination']);
define('LOGFILE', isset($args['logfile']) ? $args['logfile'] : 'save_generated.log');
define('LOCKFILE', isset($args['lockfile']) ? $args['lockfile'] : 'save_generated.lock');

/*
 $basedir = realpath('.');
$source = $basedir.'/generated';
$destination = $basedir.'/safely_generated';

define('LOCKFILE', 'save_generated.lock');
define('LOGFILE', 'save_generated.log');
*/

if(file_exists(LOCKFILE)) exit();
else{
	fclose(fopen(LOCKFILE, 'w+'));
}

function remove_lock_file(){
	global $log;
	@unlink(LOCKFILE);
	if(is_resource($log)){
		@fclose($log);
	}
	echo "\n -- Done!\n";
}
register_shutdown_function('remove_lock_file');

echo 'Source: '.SOURCE."\n";
echo 'Destination: '.DESTINATION."\n";

$log = fopen(LOGFILE, 'w');

if(!file_exists(SOURCE)) mkdir(SOURCE);
if(!file_exists(DESTINATION)) mkdir(DESTINATION);

/**
 * @var SplFileInfo
 */
$file = null;
/**
 * @var \DirectoryIterator
 */
$iterator = new \DirectoryIterator(SOURCE);
while(file_exists(LOCKFILE)){
	$iterator->rewind();
	while($iterator->valid()){
		if($iterator->isFile() && $iterator->isWritable()){
			$filename = $iterator->getBasename();
			$oldFile = SOURCE.'/'.$filename;
			if(!file_exists($oldFile)) continue;
			$genIndex = strpos($filename, '-generated');
			if($genIndex!==false){
				$filename = substr($filename, 0, $genIndex).'.'.pathinfo($filename, PATHINFO_EXTENSION);
			}
			$newFile = DESTINATION.'/'.$filename;
			if(file_exists($newFile)){
				$index = 0;
				do{
					$newFile = DESTINATION.'/'.(++$index).'_'.$filename;
				}while(file_exists($newFile));
				fwrite($log, $index.'_'.$filename.':'.$index.':'.$filename."\n");
				$filename = $index.'_'.$filename;
			}
			rename($oldFile, $newFile);
			echo $filename."\n";
		}
		$iterator->next();
	}
}
?>