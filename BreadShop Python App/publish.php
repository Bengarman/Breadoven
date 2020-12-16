<?php

require("phpMQTT.php");

$server = "broker.mqttdashboard.com";     // change if necessary
$port = 1883;                     // change if necessary
$username = "";                   // set your username
$password = "";                   // set your password
$client_id = "clientId-3ep0Qafl3h";

$mqtt = new phpMQTT($server, $port, $client_id);


if ($mqtt->connect(true, NULL)) {
	$mqtt->publish("benData/", "Hello World! at " . date("r"), 0);
	$mqtt->close();
	echo "done";
} else {
    echo "Time out!\n";
}
?>