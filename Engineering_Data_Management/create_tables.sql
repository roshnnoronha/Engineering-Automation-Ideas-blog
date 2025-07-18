CREATE TABLE Employees(
    employeeid INT NOT NULL AUTO_INCREMENT,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (employeeid)
);

CREATE TABLE Projects(
    projectid INT NOT NULL AUTO_INCREMENT,
    projectmanagerid INT NOT NULL,
    projectno VARCHAR(255) NOT NULL UNIQUE,
    projectname VARCHAR(255) NOT NULL,
    PRIMARY KEY (projectid),
    FOREIGN KEY (projectmanagerid) REFERENCES Employees (employeeid)
);

CREATE TABLE ActivityCategories(
    categoryid INT NOT NULL AUTO_INCREMENT,
    projectid INT NOT NULL,
    categoryname VARCHAR(255) NOT NULL,
    PRIMARY KEY (categoryid),
    FOREIGN KEY (projectid) REFERENCES Projects (projectid)
);

CREATE TABLE ActivitySubcategories(
    subcategoryid INT NOT NULL AUTO_INCREMENT,
    categoryid INT NOT NULL,
    subcategoryname VARCHAR(255),
    PRIMARY KEY (subcategoryid),
    FOREIGN KEY (categoryid) REFERENCES ActivityCategories (categoryid)
);


CREATE TABLE Activities(
    activityid INT AUTO_INCREMENT NOT NULL,
    subcategoryid INT NOT NULL,
    activityname VARCHAR(255) NOT NULL,
    activitydescription VARCHAR(1000),
    activitymanagerid INT NOT NULL,
    plannedstart DATE,
    plannedfinish DATE,
    forecaststart DATE,
    forecastfinish DATE,
    actualstart DATE,
    actualfinish DATE,
    plannedhours DECIMAL(10,2),
    forecasthours DECIMAL(10,2),
    PRIMARY KEY (activityid),
    FOREIGN KEY (subcategoryid) REFERENCES ActivitySubcategories (subcategoryid),
    FOREIGN KEY (activitymanagerid) REFERENCES Employees (employeeid)
);

CREATE TABLE ActivityNotes(
    noteid INT AUTO_INCREMENT NOT NULL,
    activityid INT NOT NULL,
    userid INT NOT NULL,
    note VARCHAR(2000) NOT NULL,
    notedate DATE NOT NULL,
    PRIMARY KEY (noteid),
    FOREIGN KEY (activityid) REFERENCES Activities (activityid),
    FOREIGN KEY (userid) REFERENCES Employees (employeeid)
);

CREATE TABLE ActivityTasks(
    taskid INT NOT NULL AUTO_INCREMENT,
    activityid INT NOT NULL,
    taskname VARCHAR(255) NOT NULL,
    parenttaskid INT,
    PRIMARY KEY (taskid),
    FOREIGN KEY (activityid) REFERENCES Activities(activityid)
);

CREATE TABLE ActivityTaskAssignments(
    assignmentid INT NOT NULL AUTO_INCREMENT,
    taskid INT NOT NULL,
    userid INT NOT NULL,
    assigneddate DATE,
    closedate DATE,
    PRIMARY KEY (assignmentid),
    FOREIGN KEY (taskid) REFERENCES ActivityTasks (taskid),
    FOREIGN KEY (userid) REFERENCES Employees (employeeid)
);

CREATE TABLE Hours(
    bookingid INT NOT NULL AUTO_INCREMENT,
    assignmentid INT NOT NULL,
    bookeddate DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    hours INT NOT NULL,
    PRIMARY KEY (bookingid),
    FOREIGN KEY (assignmentid) REFERENCES ActivityTaskAssignments(assignmentid)
);

CREATE TABLE ArtefactTypes(
    artefacttypeid INT AUTO_INCREMENT NOT NULL,
    projectid INT NOT NULL,
    artefactname VARCHAR(255) NOT NULL,
    artefactdescription VARCHAR(1000),
    PRIMARY KEY (artefacttypeid),
    FOREIGN KEY (projectid) REFERENCES Projects (projectid)
);

CREATE TABLE Artefacts(
    artefactid INT AUTO_INCREMENT NOT NULL,
    artefacttypeid INT NOT NULL,
    artefactownerid INT,
    artefacttitle VARCHAR(255) NOT NULL,
    PRIMARY KEY (artefactid),
    FOREIGN KEY (artefacttypeid) REFERENCES ArtefactTypes (artefacttypeid),
    FOREIGN KEY (artefactownerid) REFERENCES Employees (employeeid) 
);

CREATE TABLE ArtefactToActivityLink(
    artefactlinkid INT AUTO_INCREMENT NOT NULL,
    activityid INT NOT NULL,
    artefactid INT NOT NULL,
    ratio DECIMAL(3,2),
    PRIMARY KEY (artefactlinkid),
    FOREIGN KEY (activityid) REFERENCES Activities (activityid),
    FOREIGN KEY (artefactid) REFERENCES Artefacts (artefactid)
);

CREATE TABLE ArtefactDataFields(
    artefactdatafieldid INT AUTO_INCREMENT NOT NULL,
    artefacttypeid INT NOT NULL,
    fieldtitle VARCHAR(255) NOT NULL,
    valuetype INT NOT NULL,
    maximumlength INT,
    maximumvalue INT,
    minimumvalue INT,
    PRIMARY KEY (artefactdatafieldid),
    FOREIGN KEY (artefacttypeid) REFERENCES ArtefactTypes (artefacttypeid)
);

CREATE TABLE ArtefactData(
    artefactdataid INT AUTO_INCREMENT NOT NULL,
    artefactid INT NOT NULL,
    artefactdatafieldid INT NOT NULL,
    value VARCHAR(2000),
    PRIMARY KEY (artefactdataid),
    FOREIGN KEY (artefactid) REFERENCES Artefacts (artefactid),
    FOREIGN KEY (artefactdatafieldid) REFERENCES ArtefactDataFields (artefactdatafieldid) 
);

CREATE TABLE Milestones(
    milestoneid INT AUTO_INCREMENT NOT NULL,
    projectid INT NOT NULL,
    milestonename VARCHAR(255) NOT NULL,
    PRIMARY KEY (milestoneid),
    FOREIGN KEY (projectid) REFERENCES Projects (projectid)
);

CREATE TABLE MilestoneSteps(
    milestonestepid INT AUTO_INCREMENT NOT NULL, 
    milestoneid INT NOT NULL,
    milestonestepname VARCHAR(255) NOT NULL,
    progressratio DECIMAL(3,2) DEFAULT 0.00,
    PRIMARY KEY (milestonestepid),
    FOREIGN KEY (milestoneid) REFERENCES Milestones (milestoneid) 
);

CREATE TABLE MilestoneToArtefactLink(
    milestonelinkid INT AUTO_INCREMENT NOT NULL,
    milestonestepid INT NOT NULL,
    artefactlinkid INT NOT NULL,
    completedbyid INT,
    completiondate DATE,
    PRIMARY KEY (milestonelinkid),
    FOREIGN KEY (milestonestepid) REFERENCES MilestoneSteps (milestonestepid),
    FOREIGN KEY (artefactlinkid) REFERENCES ArtefactToActivityLink (artefactlinkid),
    FOREIGN KEY (completedbyid) REFERENCES Employees (employeeid)
); 
