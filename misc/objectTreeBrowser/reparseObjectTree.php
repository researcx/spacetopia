<?php

function usage()
{
	echo "php reparseObjectTree.php objectTree.txt objectTree.xml";
}

if (!isset($argv[1]) || !isset($argv[2])) {
	usage();
}

if (!file_exists($argv[1])) {
	echo "$argv[1]: file not found.";
}

$fp = fopen($argv[1], 'rb');
$ofp = fopen($argv[2], 'wb');
fputs($ofp, "<?xml version=\"1.0\"?>\n<tree>\n");
while(($buffer = fgets($fp, 32000)) !== false) {	
	if (empty(trim($buffer)) || strpos($buffer, "loading") === 0) {
		continue;
	}
	$buffer = preg_replace('/[^\x09\x0A\x0D\x20-\x7F]/','', $buffer);
	$buffer = str_replace(['&'], [''], $buffer);
	while (preg_match('/<([^>]+<)/', $buffer)) {
	$buffer = preg_replace('/<([^>]+<)/', '$1', $buffer);
	}
	fputs($ofp, strip_tags($buffer, '<verb><area><turf><mob><object><var><proc><val><obj>'));
}
fputs($ofp, "\n</tree>");