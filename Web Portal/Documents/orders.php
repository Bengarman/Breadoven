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
    $stmt = $conn->prepare("SELECT orderPlaced.id, user.name, orderPlaced.collectionTime, orderPlaced.paid, orderPlaced.totalPrice, orderPlaced.orderStatus, COUNT(orderLine.id) AS Items FROM orderPlaced LEFT JOIN user ON orderPlaced.userID = user.id LEFT JOIN orderLine ON orderPlaced.id = orderLine.orderPlacedID WHERE orderPlaced.orderedTime > ".$period." GROUP BY orderPlaced.id"); 
    
    $stmt->execute();

    $stmt->bind_result($id, $userName, $collectionTime, $paid, $totalPrice, $orderStatus, $totalItems);

    while ($stmt->fetch()) {
        if ($paid == 0){
            $paid = '<label class="badge badge-warning">Not Paid Yet</label>';
        }else if ($paid == 1){
            $paid = '<label class="badge badge-success">Paid on App</label>';
        }else if ($paid == 2){
            $paid = '<label class="badge badge-info">Paid on Collection</label>';
        }
        echo "<tr> <td> ".$id."</td> <td> ".$userName."</td> <td> ".$paid."</td> <td> £ ".number_format($totalPrice, 2)."</td> <td> ".$collectionTime.'</td> <td><button type="button" class="btn btn-outline-secondary btn-rounded btn-icon" onclick="reprint('.$id.')"><i class="mdi mdi-printer"></i></button> </tr> ';
    }
?>

