<?php

$eng = file('./latLinkFiner', FILE_IGNORE_NEW_LINES);

$org = file('./linkOrg', FILE_IGNORE_NEW_LINES);

foreach($org as $orgline) {
    $idx = lookup($orgline);
    if ($idx !== false) {
        $res = $eng[$idx];
        $item = explode("\t", $res);
        print $item[1] ."\t". $item[2] ."\n";
    } else {
        print "N/A\n";
    }
}

function lookup ($needle) {
    global $eng;
    foreach($eng as $i => $engline) {
        if(stripos($engline, $needle) !== false) {
            return $i;
        }
    }
    return false;
}
