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

function findTargetFileName($listPath, $name){
	$targetIndex = 0;
	if($listPath){
		$list = file_get_contents($listPath);
		$startIndex = strpos($list, $name);
		echo $startIndex."\n";
		if($startIndex!==false && ($startIndex==0 || $list[$startIndex-1]=="\n")){
			$endIndex = strpos($list, "\n", $startIndex);
			$data = explode(":", substr($list, $startIndex, $endIndex-$startIndex));
			$targetIndex = (int)$data[1];
			$name = $data[2];
			print_r($data);
		}
	}
	define('TARGET_NAME', substr($name, 1, strpos($name, '-')-1).'.'.pathinfo($name, PATHINFO_EXTENSION));
	define('TARGET_INDEX', $targetIndex);
}

$UniqueMarkIndex = 0;
function generateUniqueMark(){
	global $UniqueMarkIndex;
	$UniqueMarkIndex++;
	return '|#:-'.$UniqueMarkIndex.'-:#|';
}

//chdir('generated');
//print_r($args);
define('FILE_PATH', $args['file']);
findTargetFileName(isset($args['namesfile']) ? $args['namesfile'] : "", pathinfo(FILE_PATH, PATHINFO_BASENAME));

// find target
echo 'File Name:'.pathinfo(FILE_PATH, PATHINFO_BASENAME)."\n";
echo 'Target Name:'.TARGET_NAME."\n";
echo 'Target Index:'.TARGET_INDEX."\n";
$targetIterator = new RecursiveDirectoryIterator('.');
$iterator = new RecursiveIteratorIterator($targetIterator, RecursiveIteratorIterator::SELF_FIRST);
/** 
 * @var SplFileInfo 
 */
$file = null;
$targetIndex = 0;
$targetNameLower = strtolower(TARGET_NAME);
foreach ($iterator as $file){
	if (!$file->isFile() || $targetNameLower!=strtolower($file->getFilename())) continue;
	if($targetIndex==TARGET_INDEX){
		define('TARGET_PATH', $file->getPathname());
		break;
	}else $targetIndex++;
}
if(defined('TARGET_PATH')) echo 'Target Path:'.TARGET_PATH."\n";
else{
	echo 'Target ERROR: Target not bound for generated source from "'.FILE_PATH.'"'."\n";
	exit;
}

// replace code comments, XML comments and CDATA blocks with marks
$replacedContent = array();
$classContent = file_get_contents(TARGET_PATH);
preg_match_all('/(\/\*.*?\*\/|\<\!\-\-.*?\-\-\>|\<\!\[CDATA\[.*?\]\]\>)/s', $classContent, $replacements);
foreach($replacements[0] as $replacement){
	$mark = generateUniqueMark();
	$classContent = str_replace($replacement, $mark, $classContent);
	$replacedContent[] = array($mark, $replacement);
} 

// read bindings content
$fileContent = file_get_contents(FILE_PATH);
// $contents[1] -- all contents I should put into edited class
preg_match('/class\s+[^\{]+\{(.+)\}\s*$/ius', $fileContent, $contents);
$bindingsContent = $contents[1];

// moving imports to class content
preg_match_all('/[^\w]import\s+[\w\.\d_$]+;?/us', $bindingsContent, $imports);
$imports = "\n".implode("\n", $imports[0])."\n";
preg_match_all('/[^\w]?package[^\{]*\{/us', $classContent, $packageDefs);
foreach($packageDefs[0] as $packageDef){
	$classContent = str_replace($packageDef, $packageDef.$imports, $classContent);
}

// remove binding metadata tags from class
$classContent = str_replace('[Bindable]', '', $classContent); 

// read bindings and replacements names and apply remanes to class contents
// $bindings[1] - member type
// $bindings[2] - binding name
// $bindings[3] - new name of the original property, _56786578property
preg_match_all('/\*\s*\-\s*original\s+([^\']+)\'([^\']+)\'\s*moved\s+to\s*\'([^\']+)\'/ius', $bindingsContent, $bindings);
foreach($bindings[1] as $index=>$member){
	$bindingName = $bindings[2][$index];
	$propertyName = $bindings[3][$index];
	$memberinfo = explode(' ', preg_replace('/\s+/', ' ', trim($member)));
	$member = array_pop($memberinfo);
 	echo " - member($member): $bindingName > $propertyName\n";
	$pattern = '/((public|private|final|virtual|internal|protected)\s+';
	switch($member){
		case 'var':
			$pattern .= 'var\s+'.$bindingName;
			break;
		case 'get':
		case 'getter':
			$pattern .= 'function\s+get\s+'.$bindingName;
			break;
		case 'set':
		case 'setter':
			$pattern .= 'function\s+set\s+'.$bindingName;
			break;
		default:
			die(' - Error: Unknown Class member declataion found: '.$member.' with name '.$bindingName.' > '.$propertyName);
			break;
	}
	$pattern .= ')[^\w\d$_]/ius';
	$memberFound = false;
	// find and update property definition($bindingName) to new name($propertyName)
	preg_match_all($pattern, $classContent, $declarations);
	foreach ($declarations[1] as $memberDeclaration){
		$startIndex = 0;
		while(($index = strpos($classContent, $memberDeclaration, $startIndex))!==false){
 			echo "\tfound \"$memberDeclaration\" at $index, ";
			$memberDeclarationLen = strlen($memberDeclaration);
			$memberDeclarationNextChar = $classContent[$index+$memberDeclarationLen];
			if(!ctype_alnum($memberDeclarationNextChar) && strpos('$_', $memberDeclarationNextChar)===false){
				$memberFound = true;
				$classContent = substr($classContent, 0, $index).substr($memberDeclaration, 0, $memberDeclarationLen-strlen($bindingName)).$propertyName.substr($classContent, $index+$memberDeclarationLen);
	 			echo "renamed\n";
			}else echo "skipped\n";
			$startIndex = $index+$memberDeclarationLen;
		}
		//$classContent = str_replace($member, substr($member, 0, strlen($member)-strlen($bindingName)).$propertyName, $classContent);	
	}
	if(!$memberFound){
		$pattern = '/[^\w\d$_]_'.$bindingName.'[^\w\d$_]/ius';
		$memberDeclaration = '';
		switch($member){
			case 'var':
				$memberDeclaration .= "public var $propertyName:*;\n";
				break;
			case 'get':
			case 'getter':
				if(!preg_match($pattern, $classContent) && !preg_match($pattern, $bindingsContent)){
					$memberDeclaration .= "public function get $propertyName():*{\n\treturn _$bindingName;\n}\n";
				}
				$memberDeclaration .= "public function get $propertyName():*{\n\treturn _$bindingName;\n}\n";
				break;
			case 'set':
			case 'setter':
				if(!preg_match($pattern, $classContent) && !preg_match($pattern, $bindingsContent)){
					$memberDeclaration .= "private var _$bindingName;\n";
				}
				$memberDeclaration .= "public function set $propertyName(value:*):void{\n\t_$bindingName = value;\n}\n";
			break;
		}
		echo "\tnot found, replacing with \n$memberDeclaration\n";
		$bindingsContent .= "\n$memberDeclaration\n";
	}
}

/* Old omplementation
// read bindings and replacements names and apply remanes to class contents
// $bindings[1] - binding name
// $bindings[2] - new name of the original property, _56786578property
preg_match_all('/\*\s*\-\s*original\s+([^\']+)\'([^\']+)\'\s*moved\s+to\s*\'([^\']+)\'/ius', $bindingsContent, $bindings);
//preg_match_all('/function\s+(get\s+([^\(\s]+)[^\{]+\{\s*return\s+[^;]+?([^\.;]+);|set\s+([^\(\s]+)[^\{]+\{  NOT FINISHED )/ius', $bindingsContent, $bindings);

// replace binding names
foreach($bindings[1] as $index=>$bindingName){
	$propertyName = $bindings[2][$index];
	// find and update property definition($bindingName) to new name($propertyName)
	preg_match_all('/(public|private|final|virtual|internal|protected)\s+(function\s+(get|set)\s+'.$bindingName.'|var\s+'.$bindingName.')[^\w\d$_]/ius', $classContent, $declarations);
	foreach ($declarations[0] as $declaration){
		$nameIndex = strpos($declaration, $bindingName);
		if($nameIndex!==false){
			$newDeclaration = substr($declaration, 0, $nameIndex).$propertyName.substr($declaration, $nameIndex+strlen($bindingName));
			$classContent = str_replace($declaration, $newDeclaration, $classContent);
		}
	}
}
*/

// move back all replacements
$replacementsCount = count($replacedContent);
for($i=$replacementsCount-1; $i>=0; $i--){
	$replacement = $replacedContent[$i];
	$classContent = str_replace($replacement[0], $replacement[1], $classContent);
}

// find place for bindings inside of the class declaration and put them there  
preg_match('/^.+?\s+class\s+[^\{]+\{/ius', $classContent, $contents);
$index = strlen($contents[0]);
file_put_contents(TARGET_PATH, substr($classContent, 0, $index).$bindingsContent.substr($classContent, $index));
//@unlink(FILE_PATH);

?>