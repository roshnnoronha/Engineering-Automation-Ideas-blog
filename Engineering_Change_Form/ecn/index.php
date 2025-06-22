<?php
    #retrieve the ecnid and responseid from page get data and set the form state accordingly
    $ecnid = '';
    if (isset($_GET['ecnid'])){
        $ecnid = $_GET['ecnid'];
    }
    $responseid = '';
    if (isset($_GET['responseid'])){
        $responseid = $_GET['responseid'];
    }
    
    #connect to the ChangeManagementSystem database
    require_once 'config.php';
    $conn = new mysqli($servername, $username, $password, $database);
    if ($conn->connect_error) {
      die('Connection failed: ' . $conn->connect_error);
    }

    #get the list of disciplines
    $sql =  "SELECT disciplineid, disciplinename FROM Disciplines;";
    $result = $conn->query($sql);
    $discipines = [];
    while($row= $result->fetch_assoc())
        $disciplines [] = $row;
    $result->free_result();

    #get the list of projects
    $sql =  "SELECT projectid, projectname FROM Projects;";
    $result = $conn->query($sql);
    $projects = [];
    while($row= $result->fetch_assoc())
        $projects [] = $row;
    $result->free_result();

    #get the list of previous ECNs
    $sql = "SELECT ecnid FROM ECNData;";
    $result = $conn->query($sql);
    $ecnlist = [];
    while($row= $result->fetch_assoc())
        $ecnlist [] = $row['ecnid'];
    $result->free_result();

    $issuedbydisciplineid = '';
    $issuedtodisciplineids = '';
    $projectid = '';
    $issuedate = '';
    $description = '';
    $causedbyother = false;
    $causalecnid = '';
    $reason = '';
    $responselist = [];
    $responserequired = false;
    $notsubmitted = true;
    if ($ecnid != ''){
        $sql = "SELECT ecnid,issuedbydisciplineid,projectid,issuedate,description,causedbyother,causalecnid,reason FROM ECNData WHERE ecnid='".$ecnid."';";
        $result = $conn->query($sql);
        if (!$ecndata = $result->fetch_assoc())
            die('Invalid ECN ID.');
        $issuedbydisciplineid = $ecndata['issuedbydisciplineid'];
        $projectid = $ecndata['projectid'];
        $issuedate = $ecndata['issuedate'];
        $description = $ecndata['description'];
        if ($ecndata['causedbyother'] != 0)
            $causedbyother = true;
        $causalecnid = $ecndata['causalecnid'];
        $reason = $ecndata['reason'];
        $result->free_result();

        $sql = "SELECT responseid,issuedtodisciplineid,disciplinename, accepted,rejected,remark,responsedate,changehours FROM ECNIssues INNER JOIN Disciplines ON Disciplines.disciplineid = ECNIssues.issuedtodisciplineid WHERE ecnid='".$ecnid."';";
        $result = $conn->query($sql);
        while($row= $result->fetch_assoc()){
            $responselist [] = $row;
            if ($issuedtodisciplineids == '')
                $issuedtodisciplineids = $row['issuedtodisciplineid'];
            else
                $issuedtodisciplineids = $issuedtodisciplineids.','.$row['issuedtodisciplineid'];
        }
        $result->free_result();

        $notsubmitted = false;
    }elseif ($responseid != ''){
        $sql = "SELECT responseid,ecnid,issuedtodisciplineid, disciplinename, accepted,rejected,remark,responsedate,changehours FROM ECNIssues INNER JOIN Disciplines ON Disciplines.disciplineid = ECNIssues.issuedtodisciplineid WHERE responseid = '".$responseid."';";
        $result = $conn->query($sql);
        if (!$responsedata = $result->fetch_assoc())
            die('Invalid response ID.');
        #check if the ECN has already been responded to.
        if (($responsedata['accepted'] != 0) || ($responsedata['rejected'] != 0))
            die('You have already reponded to this ECN.');
        $responselist [] = $responsedata;
        $result->free_result();
        
        $ecnid = $responsedata['ecnid'];
        $sql = "SELECT issuedbydisciplineid, projectid,issuedate,description,causedbyother,causalecnid,reason FROM ECNData WHERE ecnid='".$ecnid."';";
        $result = $conn->query($sql);
        if (!$ecndata = $result->fetch_assoc())
            die('Invalid ECN ID.');
        $issuedbydisciplineid = $ecndata['issuedbydisciplineid'];
        $projectid = $ecndata['projectid'];
        $issuedate = $ecndata['issuedate'];
        $description = $ecndata['description'];
        if ($ecndata['causedbyother'] != 0)
            $causedbyother = true;
        $causalecnid = $ecndata['causalecnid'];
        $reason = $ecndata['reason'];
        $result->free_result();

        $sql = "SELECT issuedtodisciplineid FROM ECNIssues WHERE ecnid='".$ecnid."';";
        $result = $conn->query($sql);
        while($row= $result->fetch_assoc()){
            if ($issuedtodisciplineids == '')
                $issuedtodisciplineids = $row['issuedtodisciplineid'];
            else
                $issuedtodisciplineids = $issuedtodisciplineids.','.$row['issuedtodisciplineid'];
        }
        $result->free_result();

        $responserequired = true;
        $notsubmitted = false;
    }

    #establish the form state
    if ($notsubmitted && !$responserequired)
        $formstate = 0;         //new form
    elseif ($responserequired)
        $formstate = 1;         //open to respond to an ECN
    else
        $formstate = 2;         //open to view an ECN

    #update the dates to current date if required
    if ($formstate == 0)
        $issuedate = date('Y-m-d');
    if ($formstate == 1)
        $responselist[0]['responsedate'] = date('Y-m-d');

    #close the database connection
    $conn->close();

?>
<!DOCTYPE html>
<html lang ="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>ECN Form</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <script src="form.js"></script>
</head>
<body>
    <div class="container">
    <h1>Engineering Change Notice</h1>
    <div class="container" id="frm_details">
    <input type="hidden" id="fld_formstate" name="fld_formstate" value="<?php echo $formstate; ?>">
    <h4>ECN Details</h4>
    <br>
    <form class="form-horizontal" action="submit.php" method="get">
        <div class="form-group">
            <label for="fld_ecnid" class="form-label col-sm-2">ECN ID</label>
            <div class="col-sm-10">
            <input type="text" class="form-control submit-form-field" id="fld_ecnid" name="fld_ecnid" value="<?php echo $ecnid; ?>">
            </div>
        </div>
        <div class="form-group">
            <label for="fld_project" class="form-label col-sm-2">Project</label>
            <div class="col-sm-10">
                <select class="form-control submit-form-field" id="fld_project" name="fld_project">
                <?php
                    foreach ($projects as $project){
                        $selected = '';
                        if ($project['projectid'] == $projectid)
                            $selected = 'selected';
                        echo '<option value="'.$project['projectid'].'" '.$selected.'>'.$project['projectname'].'</option>';
                    }
                ?>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label for="fld_issuedby" class="form-label col-sm-2">Issued by</label>
            <div class="col-sm-10">
                <select class="form-control submit-form-field" id="fld_issuedby" name="fld_issuedby">
                <?php
                    foreach ($disciplines as $discipline){
                        $selected = '';
                        if ($discipline['disciplineid'] == $issuedbydisciplineid)
                            $selected = 'selected';
                        echo '<option value="'.$discipline['disciplineid'].'" '.$selected.'>'.$discipline['disciplinename'].'</option>';
                    }
                ?>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label for="fld_issuedto" class="form-label col-sm-2">Issued to</label> 
            <div class="col-sm-10">
            <input type="hidden" class="form-control submit-form-field" id="fld_issuedto" name="fld_issuedto" value="<?php echo $issuedtodisciplineids; ?>">
                <div class="list-group">
                <?php 
                    foreach ($disciplines as $discipline){
                        echo '<a href="#" class="list-group-item issued-to-discipline-list " id="disp_id_'.$discipline['disciplineid'].'">'.$discipline['disciplinename'].'</a>';
                    }
                ?>
                </div>
            </div>
        </div>
        <div class="form-group">
            <label for="fld_date" class="form-label col-sm-2">Issued date</label>
            <div class="col-sm-10">
            <input type="text" class="form-control submit-form-date-field" id="fld_date" name="fld_date" value="<?php echo $issuedate;  ?>" readonly>
            </div>
        </div>
        <div class="form-group">
            <label for="fld_desc" class="form-label col-sm-2">Description</label>
            <div class="col-sm-10">
            <textarea class="form-control submit-form-field" id="fld_desc" name="fld_desc" rows="4"><?php echo $description;  ?></textarea>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <p>Was the cause of the ECN another discipline's changes?</p>
                <input class="form-check-input submit-form-field" type="radio" id="fld_causebyothersyes" name="fld_causedbyothers" value="1" <?php if($causedbyother) echo 'checked'; ?>>                
                <label for="fld_causedbyothersyes">Yes</label>
                <input class="form-check-input submit-form-field" type="radio" id="fld_causebyothersno" name="fld_causedbyothers" value="0" <?php if(!$causedbyother) echo 'checked'; ?>>                
                <label for="fld_causedbyothersno">No</label>
            </div>
        </div>
        <div class="form-group" id="grp_causalecn">
            <label for="fld_causalecn" class="form-label col-sm-2">Causal ECN</label>
            <div class="col-sm-10">
                <select class="form-control submit-form-field" id="fld_causalecn" name="fld_causalecn">
                <?php 
                    foreach ($ecnlist as $ecn){
                        $selected = '';
                        if ($causalecnid == $ecn)
                            $selected = 'selected';
                        echo '<option value="'.$ecn.'" '.$selected.'>'.$ecn.'</option>';
                    } 
                ?>
                </select>
            </div>
        </div>
        <div class="form-group" id="grp_reason">
            <label for="fld_reason" class="form-label col-sm-2">Reason for change</label>
            <div class="col-sm-10">
            <textarea class="form-control submit-form-field" id="fld_reason" name="fld_reason" rows="4"><?php echo $reason; ?></textarea>
            </div>
        </div>
        <?php
        if ($notsubmitted){
            echo '<div class="form-group">';
            echo '<div class="col-sm-offset-2 col-sm-10">';
            echo '<button type="submit" class="btn btn-primary">Submit</button>';
            echo '</div>';
            echo '</div>';
        }
        ?>
    </form>
    </div>
    <div class="container" id="frm_response">
    <?php
    foreach ($responselist as $response){
        echo '<hr>';
        echo '<h4>ECN Response - '.$response['disciplinename'].'</h4>';
        echo '<br>';
        echo '<form class="form-horizontal" action="respond.php" method="get">';
        #
        echo '<div class="form-group">';
        echo '<div class="col-sm-offset-2 col-sm-10">';
        $checked = '';
        if ($response['accepted'] != 0)
            $checked = 'checked';
        echo '<input class="form-check-input response-form-field" type="radio" id="fld_accepted" name="fld_response" value="accepted" '.$checked.'>';
        echo '<label for="fld_acceptchange">Accepted </label>';
        $checked = '';
        if ($response['rejected'] != 0)
            $checked = 'checked';
        echo '<input class="form-check-input response-form-field" type="radio" id="fld_rejected" name="fld_response" value="rejected" '.$checked.'>';
        echo '<label for="fld_rejectchange">Rejected</label>';
        echo '</div>';
        echo '</div>';
        #
        echo '<div class="form-group">';
        echo '<label for="fld_responsedate" class="form-label col-sm-2">Response date</label>';
        echo '<div class="col-sm-10">';
        echo '<input type="text" class="form-control response-form-date-field" id="fld_responsedate" name="fld_responsedate" value="'.$response['responsedate'].'" readonly>';
        echo '</div>';
        echo '</div>';
        #
        echo '<div class="form-group">';
        echo '<label for="fld_changehours" class="form-label col-sm-2">Change hours</label>';
        echo '<div class="col-sm-10">';
        echo '<input type="text" class="form-control response-form-field" id="fld_changehours" name="fld_changehours" value="'.$response['changehours'].'">';
        echo '</div>';
        echo '</div>';
        #
        echo '<div class="form-group">';
        echo '<label for="fld_remarks" class="form-label col-sm-2">Remarks</label>';
        echo '<div class="col-sm-10">';
        echo '<textarea class="form-control response-form-field" id="fld_remarks" name="fld_remarks" rows="4">'.$response['remark'].'</textarea>';
        echo '</div>';
        echo '</div>';
        #
        echo '<input type="hidden" id="fld_responseid" name="fld_responseid" value="'.$response['responseid'].'">';
        if ($responserequired){
            echo '<div class="form-group">';
            echo '<div class="col-sm-offset-2 col-sm-10">';
            echo '<button type="submit" class="btn btn-primary">Respond</button>';
            echo '</div>';
            echo '</div>';
        }
        echo '</form>';
    }
    ?>
    </div>
    </div>
</body>
</html>

