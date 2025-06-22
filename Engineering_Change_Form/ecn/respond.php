<?php
    #connect to the ChangeManagementSystem database
    require_once 'config.php';
    $conn = new mysqli($servername, $username, $password, $database);
    if ($conn->connect_error) {
      die('Connection failed: ' . $conn->connect_error);
    }

    #check if the submission has a valid ECN ID
    if ((!isset($_GET['fld_responseid'])) && (!isset($_GET['fld_response']))){
        $conn->close();
        die('Invalid response.'); 
    }

    #get response data
    $remark = $_GET['fld_remarks'];
    $responsedate = $_GET['fld_responsedate'];
    $changehours = $_GET['fld_changehours'];
    $responseid = $_GET['fld_responseid'];

    #check if ECN has already been responded to
    $stmt = $conn->prepare("SELECT accepted,rejected FROM ECNIssues WHERE responseid=?;");
    $stmt->bind_param('s',$responseid);
    $stmt->execute();
    $stmt->bind_result($accepted,$rejected); 
    $stmt->fetch();
    if ($accepted || $rejected)
        die('This ECN has already been responded to.');
    $stmt->close();

    if ($_GET['fld_response'] == 'accepted'){
        $accepted = 1;
        $rejected = 0;
    }else{
        $accepted = 0;
        $rejected = 1;
    }
    
    #update the response in the database
    $stmt = $conn->prepare("UPDATE ECNIssues SET accepted=?,rejected=?, remark=?,responsedate=?,changehours=? WHERE responseid=?;");
    $stmt->bind_param('iissds',$accepted,$rejected,$remark,$responsedate,$changehours,$responseid);
    if (!$stmt->execute())
       die('Unable to send the response.'); 
    $stmt->close();

    #close the connection
    $conn->close();

    echo 'Response sent successfully!';
?>
