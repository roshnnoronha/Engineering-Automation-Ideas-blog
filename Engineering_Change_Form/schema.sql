DROP DATABASE ChangeManagementSystem;

CREATE DATABASE ChangeManagementSystem;

USE ChangeManagementSystem;

CREATE TABLE Projects (
    projectid INT NOT NULL AUTO_INCREMENT,
    projectname VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (projectid)
);


CREATE TABLE Disciplines (
    disciplineid INT NOT NULL AUTO_INCREMENT,
    disciplinename VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (disciplineid)
);



CREATE TABLE Employees (
    employeeid INT NOT NULL AUTO_INCREMENT,
    disciplineid INT NOT NULL,
    projectid INT NOT NULL,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    islead BOOLEAN DEFAULT 0,
    PRIMARY KEY (employeeid),
    FOREIGN KEY (disciplineid) REFERENCES Disciplines (disciplineid), 
    FOREIGN KEY (projectid) REFERENCES Projects (projectid) 
);



CREATE TABLE ECNData (
    ecnid VARCHAR(255) NOT NULL UNIQUE,
    issuedbydisciplineid INT NOT NULL,
    projectid INT NOT NULL,
    issuedate DATE NOT NULL,
    description VARCHAR(2000) NOT NULL,
    causedbyother BOOLEAN DEFAULT 0,
    causalecnid VARCHAR(255),
    originalecnid VARCHAR(255) NOT NULL,
    reason VARCHAR(2000),
    PRIMARY KEY (ecnid),
    FOREIGN KEY (issuedbydisciplineid) REFERENCES Disciplines (disciplineid),
    FOREIGN KEY (projectid) REFERENCES Projects (projectid)
);




CREATE TABLE ECNIssues (
    issueid INT NOT NULL AUTO_INCREMENT,
    ecnid VARCHAR(255) NOT NULL,
    issuedtodisciplineid INT NOT NULL,
    accepted BOOLEAN DEFAULT 0,
    rejected BOOLEAN DEFAULT 0,
    remark VARCHAR(2000),
    responsedate DATE ,
    changehours DECIMAL(10,2) DEFAULT 0,
    responseid VARCHAR(32) NOT NULL,
    PRIMARY KEY (issueid),
    FOREIGN KEY (ecnid) REFERENCES ECNData (ecnid),
    FOREIGN KEY (issuedtodisciplineid) REFERENCES Disciplines (disciplineid)
);

