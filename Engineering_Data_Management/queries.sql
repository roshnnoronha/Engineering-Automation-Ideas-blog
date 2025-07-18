--Query to get the activity details
SELECT  
    Activities.activityname AS Activity_Name,
    Activities.activitydescription AS Description, 
    Projects.projectno AS Project_Number,
    Projects.projectname AS Project_Name,
    ActivityCategories.categoryname AS Category,
    ActivitySubcategories.subcategoryname AS Subcategory,
    CONCAT(Employees.firstname,' ' ,Employees.lastname) AS Activity_Manager,
    Activities.plannedstart AS Planned_Start,
    Activities.plannedfinish AS Planned_Finish,
    Activities.forecaststart AS Forecast_Start,
    Activities.forecastfinish AS Forecast_Finish,
    Activities.actualstart AS Actual_Start,
    Activities.actualfinish AS Actual_Finish,
    Activities.plannedhours AS Planned_Hours,
    Activities.forecasthours AS Forecast_Hours,
    SUM(Hours.hours) AS Consumed_Hours 
FROM Activities
INNER JOIN ActivitySubcategories ON Activities.subcategoryid = ActivitySubcategories.subcategoryid
INNER JOIN ActivityCategories ON ActivitySubcategories.categoryid = ActivityCategories.categoryid
INNER JOIN Projects ON ActivityCategories.projectid = Projects.projectid 
INNER JOIN Employees ON Activities.activitymanagerid = Employees.employeeid
INNER JOIN ActivityTasks ON ActivityTasks.activityid = Activities.activityid
INNER JOIN ActivityTaskAssignments ON ActivityTaskAssignments.taskid = ActivityTasks.taskid
INNER JOIN Hours ON Hours.assignmentid = ActivityTaskAssignments.assignmentid
WHERE Activities.activityid = 2;

--Query to get the activity notes
SELECT
   note AS Note,
   concat(Employees.firstname,' ' ,Employees.lastname) AS Note_By,
   notedate AS Note_Date
FROM ActivityNotes
INNER JOIN Activities ON ActivityNotes.activityid = Activities.activityid
INNER JOIN Employees ON ActivityNotes.userid = Employees.employeeid 
WHERE Activities.activityid = 2; 

--Query to list the details of all the tasks in an activity
SELECT
    ActivityTasks.taskname AS Task_Name,
    concat(Employees.firstname,' ' ,Employees.lastname) AS Assigned_To,
    ActivityTaskAssignments.assigneddate AS Assigned_Date,
    ActivityTaskAssignments.closedate AS Closed_Date, 
    SUM(Hours.hours) AS Booked_Hours
FROM ActivityTasks
INNER JOIN ActivityTaskAssignments ON ActivityTasks.taskid = ActivityTaskAssignments.taskid
INNER JOIN Employees ON ActivityTaskAssignments.userid = Employees.employeeid
INNER JOIN Hours ON ActivityTaskAssignments.assignmentid = Hours.assignmentid
WHERE ActivityTasks.activityid = 2
GROUP BY ActivityTasks.taskname
ORDER BY Assigned_Date;

--Get the details of an artefact
SELECT 
    "Artefact Type" AS Field, 
    ArtefactTypes.artefactname AS Value
FROM ArtefactTypes
INNER JOIN Artefacts ON ArtefactTypes.artefacttypeid = Artefacts.artefacttypeid
WHERE Artefacts.artefactid = 2
UNION
SELECT
    "Artefact Title" AS Field,
    Artefacts.artefacttitle AS Value
FROM Artefacts
WHERE Artefacts.artefactid = 2
UNION
SELECT 
    ArtefactDataFields.fieldtitle AS Field,
    ArtefactData.value AS Value
FROM ArtefactDataFields
INNER JOIN ArtefactData ON ArtefactDataFields.artefactdatafieldid = ArtefactData.artefactdatafieldid
WHERE ArtefactData.artefactid = 2; 

--Get the milestones details.
SELECT 
    milestonestepname, 
    CASE
        WHEN ISNULL(MilestoneToArtefactLink.completiondate) THEN 'In progress'
        ELSE 'Complete'
    END AS Status,
    CASE 
        WHEN ISNULL(MilestoneToArtefactLink.completedbyid) THEN '-'
        ELSE CONCAT (Employees.firstname, ' ' , Employees.lastname)
    END AS Completed_By
FROM MilestoneSteps 
INNER JOIN Milestones ON MilestoneSteps.milestoneid = Milestones.milestoneid 
INNER JOIN MilestoneToArtefactLink ON MilestoneToArtefactLink.milestonestepid = MilestoneSteps.milestonestepid 
INNER JOIN ArtefactToActivityLink ON ArtefactToActivityLink.artefactlinkid = MilestoneToArtefactLink.artefactlinkid 
LEFT JOIN Employees ON MilestoneToArtefactLink.completedbyid = Employees.employeeid
WHERE MilestoneToArtefactLink.artefactlinkid = 1;

--Query to get a summary of artefacts
SELECT
    ArtefactTypes.artefactname AS Artefact,
    Artefacts.artefacttitle AS Title,
    MAX(MilestoneSteps.progressratio)*100 AS Progress,
    CASE 
        WHEN MAX(MilestoneSteps.progressratio)<1 THEN 'In-progress'
        ELSE 'Complete'
    END AS Status
FROM Artefacts
INNER JOIN ArtefactTypes ON Artefacts.artefacttypeid = ArtefactTypes.artefacttypeid
INNER JOIN ArtefactToActivityLink ON Artefacts.artefactid = ArtefactToActivityLink.artefactid
INNER JOIN MilestoneToArtefactLink ON ArtefactToActivityLink.artefactlinkid = MilestoneToArtefactLink.artefactlinkid
INNER JOIN MilestoneSteps ON MilestoneToArtefactLink.milestonestepid = MilestoneSteps.milestonestepid
WHERE ArtefactToActivityLink.activityid = 1 AND NOT ISNULL(MilestoneToArtefactLink.completiondate) 
GROUP BY Artefacts.artefactid;

