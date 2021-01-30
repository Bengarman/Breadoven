<?php

require("phpMQTT.php");


$number = $_GET["data"];

$server = "broker.mqttdashboard.com";
$port = 1883;
$username = "";
$password = "";
$client_id = uniqid();

$mqtt = new phpMQTT($server, $port, $client_id);

if ($mqtt->connect(true, NULL)) {
	$mqtt->publish("newOrderGarmanApps/", "Reprint Quick kit Order Number:$number");
	$mqtt->close();
	echo "New Quick Kit Order Number:$number";
} else {
    echo "Time out!\n";
}
?>