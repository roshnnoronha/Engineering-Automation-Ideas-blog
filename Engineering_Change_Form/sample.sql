
INSERT INTO Projects (projectname) VALUES ('Project Alpha');

INSERT INTO Disciplines (disciplinename) VALUES
('Civil'),('Mechanical'),('Electrical'),('Instrumentation'),('Process'),('Site team');

INSERT INTO Employees (firstname, lastname, email, disciplineid, islead, projectid) VALUES
('Gabriel','Elliott','Gabriel.Elliott@orgiz.com',1,1,1),
('Eddie','Jennings','Eddie.Jennings@orgiz.com',1,0,1),
('Marianne','Rich','Marianne.Rich@orgiz.com',2,1,1),
('Robin','Higgins','Robin.Higgins@orgiz.com',2,0,1),
('Trudy','Lee','Trudy.Lee@orgiz.com',3,1,1),
('Frankie','Hanna','Frankie.Hanna@orgiz.com',3,0,1),
('Johnathan','Leblanc','Johnathan.Leblanc@orgiz.com',4,1,1),
('Stanford','Anderson','Stanford.Anderson@orgiz.com',4,0,1),
('Todd','Pratt','Todd.Pratt@orgiz.com',5,1,1),
('Leila','Hensley','Leila.Hensley@orgiz.com',5,0,1),
('Evan','Vasquez','Evan.Vasquez@orgiz.com',6,1,1),
('Edith','Brock','Edith.Brock@orgiz.com',6,0,1);

INSERT INTO ECNData (ecnid, issuedbydisciplineid, issuedate, description, causedbyother, causalecnid, reason, originalecnid, projectid) VALUES
('ECN-CIV-001',1,'2025-06-10','Due to the change in vendor data, equipment foundation drawings will have to be revised. Site team adviced to hold construction activities till drawings will hold marks is issued.',1,'ECN-MEC-001',NULL,'ECN-PRO-001',1),
('ECN-CIV-002',1,'2025-06-20','Due to change in vendor information the foundation details needs to be kept on hold.',1,'ECN-MEC-002',NULL,'ECN-MEC-002',1),
('ECN-ELE-001',3,'2025-06-10','Changes in cable layout around equipment will affect the structure of the platforms around the equipment.',1,'ECN-PRO-001',NULL,'ECN-PRO-001',1),
('ECN-MEC-001',2,'2025-06-10','Change in equipment size requires an update to the equiment vendor data provided to Civil which will result in change in foundation loads',1,'ECN-PRO-001',NULL,'ECN-PRO-001',1),
('ECN-MEC-002',2,'2025-06-20','Due to change in vendor data the location of the vessel 002 will have to be relocated.',0,'ECN-CIV-001','Change in vendor data.','ECN-MEC-002',1),
('ECN-PRO-001',5,'2025-06-10','Change in flow rate requires a resizing of equipment.',0,NULL,'Error in calculation.','ECN-PRO-001',1);

INSERT INTO ECNIssues (ecnid, issuedtodisciplineid, accepted, rejected, remark,responsedate,changehours,responseid) VALUES
('ECN-PRO-001',2,1,0,NULL,'2025-06-10',25.00,'4861426599b393aa57acfbac9868ef97'),
('ECN-PRO-001',3,1,0,NULL,'2025-06-10',20.00,'5ccd72fcbcf02c23c2955c46913c7f3d'),
('ECN-PRO-001',4,1,0,NULL,'2025-06-10',10.00,'2bf7c24fe34a2ebfd45797831b4516d9'),
('ECN-MEC-001',1,1,0,NULL,'2025-06-10',35.00,'bee323842c6be66a9b7d37d95a0624c9'),
('ECN-ELE-001',1,1,0,NULL,'2025-06-10',25.00,'a71e542cccf4f139cef585acea9b4de7'),
('ECN-CIV-001',6,0,0,NULL,NULL,0.00,'94614631cc8af285e7ad80b929adea1c'),
('ECN-MEC-002',1,1,0,'Foundation drawings will be revised.','2025-06-20',20.00,'524f3d663be811768ed509f2cc77572e'),
('ECN-MEC-002',3,1,0,NULL,'2025-06-20',10.00,'7250f50862ae592003c1b94a3ce74a11'),
('ECN-MEC-002',4,1,0,NULL,'2025-06-20',5.00,'52a22369e25799f4050e20769079b881'),
('ECN-CIV-002',6,0,1,'This foundation has already been cast. We need to find alternative solutions.','2025-06-20',0.00,'879bda7a9e48a42f62d8930b0fa3f2e2');
