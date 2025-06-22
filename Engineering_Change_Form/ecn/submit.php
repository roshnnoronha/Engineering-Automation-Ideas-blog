<?php
    #connect to the ChangeManagementSystem database
    require_once 'config.php';
    $conn = new mysqli($servername, $username, $password, $database);
    if ($conn->connect_error) {
      die('Connection failed: ' . $conn->connect_error);
    }

    #check if the submission has a valid ECN ID
    if (!isset($_GET['fld_ecnid'])){
        $conn->close();
        die('Invalid submission.'); 
    }

    #get the submitted data
    $ecnid = $_GET['fld_ecnid'];
    $issuedbydisciplineid = $_GET['fld_issuedby'];
    $projectid = $_GET['fld_project'];
    $issuedate = $_GET['fld_date'];
    $description = $_GET['fld_desc'];
    $causedbyother = $_GET['fld_causedbyothers'];
    $causalecnid = $_GET['fld_causalecn'];
    $reason = $_GET['fld_reason'];

    #check to ensure that the ECN ID provided is unique
    $stmt = $conn->prepare("SELECT ecnid FROM ECNData WHERE ecnid=?;");
    $stmt->bind_param('s',$ecnid);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result->num_rows>0){
        $conn->close();
        die('Duplicate ECN ID.');
    }
    $stmt->close();

    #get the originalecnid from the causal ecn
    if (!$causalecnid){
        $originalecnid = $ecnid;
    }else{
        $stmt = $conn->prepare("SELECT originalecnid FROM ECNData WHERE ecnid=?;");
        $stmt->bind_param('s',$causalecnid);
        $stmt->execute();
        $stmt->bind_result($originalecnid); 
        $stmt->fetch();
        $stmt->close();
    }

    #create a new item in the ECNData table with the values in $_GET
    $stmt = $conn->prepare("INSERT INTO ECNData (ecnid, issuedbydisciplineid, projectid, issuedate, description, causedbyother, causalecnid, reason, originalecnid) VALUES (?,?,?,?,?,?,?,?,?);");
    $stmt->bind_param('siississs',$ecnid,$issuedbydisciplineid,$projectid,$issuedate,$description,$causedbyother,$causalecnid,$reason,$originalecnid);
    if (!$stmt->execute())
        insert_error_handler($ecnid);
    $stmt->close();

    #get an array of all the disciplines to issue the ECN to 
    $issuedtoids = explode(',',$_GET['fld_issuedto']);
    foreach ($issuedtoids as $issuedtodisciplineid){
        #get the discipline name to calculate the responseid hash
        $stmt = $conn->prepare("SELECT  disciplinename FROM Disciplines WHERE disciplineid = ?;");
        $stmt->bind_param('i', $issuedtodisciplineid);
        if (!$stmt->execute())
            insert_error_handler($ecnid);
        $stmt->bind_result($disciplinename); 
        $stmt->fetch();
        $stmt->close();

        #calculate the responseid hash
        $responseid = md5($salt.$ecnid.$disciplinename);
        
        #create a new item in ECNIssues table
        $stmt = $conn->prepare("INSERT INTO ECNIssues (ecnid, issuedtodisciplineid, responseid) VALUES (?,?,?);");
        $stmt->bind_param('sis',$ecnid, $issuedtodisciplineid,$responseid);
        if (!$stmt->execute())
            insert_error_handler($ecnid);
        $stmt->close();

        #send an email notifying about the ECN
        $stmt = $conn->prepare("SELECT email, islead FROM Employees WHERE disciplineid =?;");
        $stmt->bind_param('i',$issuedtodisciplineid);
        if (!$stmt->execute())
            insert_error_handler($ecnid);
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()){
            $email = $row['email'];
            $islead = $row['islead']; 
            $subject = 'Engineering change notice #'.$ecnid;
            $message = "An Engineering Change Notice has been issued to you. You can view the ECN using the below link: \n";       
            $message = $message."/localhost/form.php?ecnid=".$ecnid."\n\n";
            if ($islead){
                $message = $message."To respond to the ECN please use the below link:\n";
                $message = $message."/localhost/form.php?responseid=".$responseid;
            }
            $message = wordwrap($message,70);
            mail($email,$subject,$message);  
        }
        $stmt->close();
    }    

    #close the connection
    $conn->close();

    echo 'Form submitted sucessfully!';

    #
    #function to handle errors in accessing the database
    function insert_error_handler($ecnid){
        global $conn;
        #ensure that any data that was inserted in deleted before exiting
        $stmt = $conn->prepare("DELETE FROM ECNIssues WHERE ecnid=?;");
        $stmt->bind_param('s',$ecnid);
        $stmt->execute();
        $stmt->close();
        $stmt = $conn->prepare("DELETE FROM ECNData WHERE ecnid=?;");
        $stmt->bind_param('s',$ecnid);
        $stmt->execute();
        $stmt->close();
        $conn->close(); 
        die('There was an error submitting form.');
    } 
?>

