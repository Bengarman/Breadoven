<?php
    $str = file_get_contents('tempFile.json');
    $json = json_decode($str, true);
    $period = $json["period"];
    //Connect to database
    $servername = "62.75.152.102";
    $username = "login";
    $password = "GA2019!?";
    $dbname = "fishie";
    $conn = new mysqli($servername, $username, $password, $dbname); 

    //Check Connection hasnt failed
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error); 
    }
    //Hard written sql script
    $stmt = $conn->prepare("SELECT COUNT(orderPlaced.id) AS Items FROM orderPlaced WHERE orderPlaced.orderedTime > ".$period); 
    $stmt->execute();
    $stmt->bind_result($count);
     
    while ($stmt->fetch()) {
        echo '<div class="col-xl-3 col-lg-6 col-sm-6 grid-margin stretch-card"><div class="card"><div class="card-body text-center"><h5 class="mb-2 text-dark font-weight-normal">Orders</h5><h2 class="mb-2 text-dark font-weight-bold">'.$count.'</h2></div></div></div>';
        
    }

    $stmt2 = $conn->prepare("SELECT COUNT(orderLine.id) AS Items FROM orderPlaced LEFT JOIN orderLine ON orderPlaced.id = orderLine.orderPlacedID WHERE orderPlaced.orderedTime > ".$period); 
    $stmt2->execute();
    $stmt2->bind_result($count);
     
    while ($stmt2->fetch()) {
        echo '<div class="col-xl-3 col-lg-6 col-sm-6 grid-margin stretch-card"><div class="card"><div class="card-body text-center"><h5 class="mb-2 text-dark font-weight-normal">Items Sold</h5><h2 class="mb-2 text-dark font-weight-bold">'.$count.'</h2></div></div></div>';
        
    }

    $stmt3 = $conn->prepare("SELECT COUNT(orderPlaced.id) AS Items FROM orderPlaced WHERE orderPlaced.orderedTime > ".$period." AND (orderPlaced.paid = 0 or orderPlaced.paid = 2)"); 
    $stmt3->execute();
    $stmt3->bind_result($count);
     
    while ($stmt3->fetch()) {
        echo '<div class="col-xl-3 col-lg-6 col-sm-6 grid-margin stretch-card"><div class="card"><div class="card-body text-center"><h5 class="mb-2 text-dark font-weight-normal">Paid on App</h5><h2 class="mb-2 text-dark font-weight-bold">'.$count.'</h2></div></div></div>';
        
    }

    $stmt4 = $conn->prepare("SELECT COUNT(orderPlaced.id) AS Items FROM orderPlaced WHERE orderPlaced.orderedTime > ".$period." AND orderPlaced.paid = 1"); 
    $stmt4->execute();
    $stmt4->bind_result($count);
     
    while ($stmt4->fetch()) {
        echo '<div class="col-xl-3 col-lg-6 col-sm-6 grid-margin stretch-card"><div class="card"><div class="card-body text-center"><h5 class="mb-2 text-dark font-weight-normal">Paid on Collection</h5><h2 class="mb-2 text-dark font-weight-bold">'.$count.'</h2></div></div></div>';
        
    }
?>