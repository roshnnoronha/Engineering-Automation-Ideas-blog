
INSERT INTO Employees (firstname,lastname,email,password)
VALUES
('Paul','Sharp','paul.sharp@organiz.com','ajds435kjad'),  
('Rebecca','Henderson','rebecca.henderson@organiz.com','ihfdgjh23h98'),  
('Anne','Mills','anne.mills@organiz.com','jhjhfgkjn35n'),  
('Edward','Poole','edward.poole@organiz.com','hjbvirj84n'),  
('Blake','Ball','blake.ball@organiz.com','igrkjnghoid94u5');  

INSERT INTO Projects (projectmanagerid, projectno , projectname)
VALUES
(2, 'PROJ1' ,'Residential Building Project');

INSERT INTO ActivityCategories (projectid,categoryname)
VALUES
(1,'House building');  

INSERT INTO ActivitySubcategories (categoryid,subcategoryname)
VALUES
(1,'Archictectural drawings'),
(1,'Structural drawings'),  
(1,'Plumbing drawings'),  
(1,'Electrical drawings');  

INSERT INTO Activities (subcategoryid,activityname,activitydescription,activitymanagerid,plannedstart,plannedfinish,forecaststart,forecastfinish,actualstart,actualfinish,plannedhours,forecasthours)
VALUES
(1,'Prepare architectural drawings','Preparation of architectural drawings for the building.',3,'2025-03-20','2025-04-17','2025-03-20','2025-04-17','2025-03-19','2025-04-18',140,150),
(2,'Prepare structural drawings','Analysis and design of the building and preparation of structural drawings and calculations.',3,'2025-04-03','2025-04-30','2025-04-04','2025-04-30','2025-04-04','2025-04-27',200,250),     
(3,'Prepare plumbing drawings','Preparation of plumbing drawings for the building.',3,'2025-04-10','2025-05-01','2025-04-11','2025-05-01','2025-04-14','2025-05-05',160,160),      
(4,'Prepare electrical wiring drawings','Preparation of electrical drawings.',3,'2025-04-20','2025-05-10','2025-04-20','2025-05-10','2025-04-24','2025-05-15',150,175);      

INSERT INTO ActivityNotes (activityid,userid,note,notedate)
VALUES
(2,3,'Details for plumbing and electrical are on hold.','2025-04-10');

INSERT INTO ActivityTasks (activityid,taskname,parenttaskid)
VALUES
(2,'1.0 Review architectural drawings',0),  
(2,'2.0 3D model preparation',0),  
(2,'2.1 Prepare a preliminary 3D model',2),  
(2,'2.2 Prepare final 3D model',2),  
(2,'2.3 Perform clash check',2),  
(2,'3.0 Analysis and design',0),  
(2,'3.1 Define the structure geometry',6),  
(2,'3.2 Apply the loads on the analysis model',6),    
(2,'3.3 Define the design parameters for the model',6),    
(2,'3.4 Run the analysis and optimize the design',6),  
(2,'4.0 Drawing prepartion',0),  
(2,'4.1 Prepare input for drawing drafting',11), 
(2,'4.2 Drawing preparation',11),   
(2,'4.3 Drawing review',11),   
(2,'4.4 Drawing comment incorporation',11), 
(2,'5.0 Calculation report compilation',0),  
(2,'5.1 Calculation preparation',16), 
(2,'5.2 Calculation review',16),   
(2,'5.3 Calculation comment incorporation',16),   
(2,'6.0 Interdisciplinary checks',0),    
(2,'6.1 Perform disciplinary checks',20),   
(2,'6.2 Incorporate comments',20),   
(2,'7.0 Document Approval',0);    

INSERT INTO ActivityTaskAssignments (taskid,userid,assigneddate,closedate)
VALUES
(1  ,4,'2025-04-04','2025-04-07'),   
(3  ,5,'2025-04-04','2025-04-09'),   
(7  ,4,'2025-04-07','2025-04-08'),   
(8  ,4,'2025-04-08','2025-04-09'),     
(9  ,4,'2025-04-09','2025-04-10'),     
(10 ,4,'2025-04-10','2025-04-10'),   
(12 ,4,'2025-04-11','2025-04-11'),   
(4  ,5,'2025-04-12','2025-04-13'),   
(5  ,5,'2025-04-13','2025-04-14'),   
(13 ,5,'2025-04-14','2025-04-15'),   
(14 ,4,'2025-04-16','2025-04-16'),     
(15 ,5,'2025-04-17','2025-05-17'),     
(17 ,4,'2025-04-12','2025-05-15'),   
(18 ,3,'2025-04-16','2025-04-17'),   
(19 ,4,'2025-04-18','2025-04-19'),   
(21 ,1,'2025-04-20','2025-04-23'),     
(22 ,5,'2025-04-24','2025-04-25'),     
(23 ,2,'2025-04-26','2025-04-27');   

INSERT INTO Hours (assignmentid, bookeddate , hours )
VALUES
(1,'2025-04-04',3),  
(1,'2025-04-05',3),  
(1,'2025-04-06',3),  
(1,'2025-04-07',3),  
(2,'2025-04-04',2),  
(2,'2025-04-05',3),  
(2,'2025-04-06',3),  
(2,'2025-04-07',3),  
(2,'2025-04-08',3),  
(2,'2025-04-09',3),  
(3,'2025-04-07',8),  
(3,'2025-04-08',8),  
(4,'2025-04-08',8),  
(4,'2025-04-09',8),  
(5,'2025-04-09',8),  
(5,'2025-04-10',8),  
(6,'2025-04-10',8),  
(7,'2025-04-11',8),  
(8,'2025-04-12',8),  
(8,'2025-04-13',4),  
(9,'2025-04-13',4),  
(9,'2025-04-14',4),  
(10,'2025-04-14',4),  
(10,'2025-04-15',8),  
(11,'2025-04-16',8),  
(12,'2025-04-17',8),  
(13,'2025-04-12',8),  
(13,'2025-04-13',8),  
(13,'2025-04-14',8),  
(14,'2025-04-16',8),  
(14,'2025-04-17',8),  
(15,'2025-04-18',8),  
(15,'2025-04-19',8),  
(16,'2025-04-20',4),  
(16,'2025-04-21',4),  
(16,'2025-04-22',4),  
(16,'2025-04-23',4),  
(17,'2025-04-24',8),  
(17,'2025-04-25',8),  
(18,'2025-04-26',3),  
(18,'2025-04-27',3);  

INSERT INTO ArtefactTypes(projectid,artefactname,artefactdescription)
VALUES
(1,'Drawings','A list of drawings in the project.'),   
(1,'Concrete','Quantity of concrete in drawings issued to site.'),   
(1,'Comments','A list of internal comments for an activity.');   

INSERT INTO Artefacts( artefacttypeid , artefactownerid, artefacttitle)
VALUES
(1, 2 ,'DWG-01'),   
(1, 2 ,'DWG-02'),   
(1, 2 ,'DWG-03'),  
(2, 3 ,'Footings'),  
(2, 3 ,'Columns'),  
(2, 3 ,'Beams'),  
(2, 3 ,'Slabs'),  
(3, 4 ,'Comment#01'),  
(3, 4 ,'Comment#02');  

INSERT INTO ArtefactToActivityLink ( activityid , artefactid , ratio)
VALUES
(2,1,1.0),  
(2,2,1.0),  
(2,3,1.0),  
(2,4,1.0),  
(2,5,1.0),  
(2,6,1.0),  
(2,7,1.0),  
(2,8,1.0),  
(2,9,1.0);  

INSERT INTO ArtefactDataFields(artefacttypeid,fieldtitle,valuetype,maximumlength,maximumvalue,minimumvalue)
VALUES
(1,'Drawing number',1,15,null,null),     
(1,'Drawing title',1,255,null,null),     
(1,'Revision',1,2,null,null),     
(1,'Revision purpose',1,25,null,null),     
(1,'Prepared by',1,255,null,null),     
(1,'Checked by',1,255,null,null),     
(1,'Approved by',1,255,null,null),     
(2,'Concrete (cum)',2,null,0,9999999),     
(3,'Comment',1,2000,null,null),        
(3,'Response',1,2000,null,null);        

INSERT INTO ArtefactData(artefactid,artefactdatafieldid,value)
VALUES
(1,1,'12345-DWG-1001'),  
(1,2,'Foundation Plan'),  
(1,3,'0'),
(1,4,'IFC'),  
(1,5,'Blake Ball'),  
(1,6,'Edward Poole'),  
(1,7,'Anne Mills'),  
(2,1,'12345-DWG-1002'),  
(2,2,'Ground Floor Plan'),  
(2,3,'0'),
(2,4,'IFC'),  
(2,5,'Blake Ball'),  
(2,6,'Edward Poole'),  
(2,7,'Anne Mills'),  
(3,1,'12345-DWG-1003'),  
(3,2,'Roof Beam Plan'),  
(3,3,'0'),
(3,4,'IFC'),  
(3,5,'Blake Ball'),  
(3,6,'Edward Poole'),  
(3,7,'Anne Mills'),  
(4,8,'18'),  
(5,8,'9'),  
(6,8,'10'),  
(7,8,'25'),  
(8,9,'Incorrect grade of concrete used. Check specification.'),  
(8,10,'Corrected'),  
(9,9,'Add reference to the specification in drawing.'),  
(9,10,'Incorporated');  

INSERT INTO Milestones(projectid,milestonename)
VALUES
(1,'Document progress'),  
(1,'Comments');

INSERT INTO MilestoneSteps(milestoneid,milestonestepname,progressratio)
VALUES
(1,'Discipline check',0.50),  
(1,'Inter-discipline check',0.75),  
(1,'Issue for construction',1.00),  
(2,'Responded',0.50),  
(2,'Accepted',1.00);  

INSERT INTO MilestoneToArtefactLink(milestonestepid , artefactlinkid , completiondate , completedbyid)  
VALUES
(1,1,'2025-04-17',5),  
(2,1,'2025-04-25',5), 
(3,1,null,null),  
(1,2,'2025-04-17',5),  
(2,2,'2025-04-25',5), 
(3,2,null,null),  
(1,3,'2025-04-17',5),  
(2,3,null,null),  
(3,3,null,null),  
(1,4,'2025-04-17',5),  
(2,4,'2025-04-25',5), 
(3,4,null,null),  
(1,5,'2025-04-17',5),  
(2,5,'2025-04-25',5), 
(3,5,null,null),  
(1,6,'2025-04-17',5),  
(2,6,null,null),  
(3,6,null,null),  
(1,7,'2025-04-17',5),  
(2,7,null,null),  
(3,7,null,null),  
(4,8,'2025-04-16',4),  
(5,8,'2025-04-19',5), 
(4,9,'2025-04-16',4),  
(5,9,null,null);  
