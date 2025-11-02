# Schedule System

## Core features and responsibilities

### Feature: Viewing the timetable (student)

As a student, I want to be able to see my timetable s.t. I know when and where the courses take place

#### Feature breakdown

0. The student logs in
1. The timetable for the current week shows each course's (which the student is enrolled into) lecture and practical time slots
2. If a course button is pressed in the schedule, a course detail page is opened ('Viewing the course info' feature)
3. If the 'Whole year' button is pressed, the schedule for the whole year is shown

#### Responsibilities

##### Business responsibilities
* Load the student's enrolled courses
* For each course, load the lecture and practical timeslots, also load their availability this week
* Load the individual course info
* Load the timetable for the whole year

##### Presentation responsibilities
* Display the timetable
* Display the 'Whole year' button
* Display the whole year timetable



### Feature: Viewing the course info (student)

As a student, I want to see the course info s.t. I know the course's details

#### Feature breakdown

0. The student logs in
1. The student can view the course's teacher by pressing the link with teacher's full name
2. If the student presses the 'Enroll' button, the student is redirected to the course enrollment page
3. If the student presses the 'Exam dates' button, the student is taken to the exam dates page
4. Pressing the 'View in timetable' button redirects the student to the course timetable page
5. The course statistics are shown in the page

#### Responsibilities

##### Business responsibilities
* Load the teacher's info page
* Load the enrollment form
* Load the course examination dates
* Load the course timetable
* Load the course statistics

##### Presentation responsibilities
* Display a teacher's link
* Display an 'Enroll' button
* Display an 'Exam dates' button
* Display a 'View in timetable' button
* Display the course statistics


### Auxiliary feature: Viewing the course info (teacher)



### Feature: Viewing the teacher info – office hours (student)
As a student, I want to see the office hours of a determined teacher.

## Feature breakdown
0.	The student logins into the system
1.	The system identifies the student and let him enter to the app in student mode.
2.	“Teachers” button should be available in the central pannel
3.	When the student presses the “Teachers” button, the system must redirect him to the teacher search window
4.	The student enters the info about the teacher in the search pannel.
5.	The system loads the information to the database in order to find the desired teacher profile
6.	The system loads the information of the database to the presentation layer of the student
7.	When the desired teacher profile is selected, the system must redirect the student to the personal teacher window
8.	There, many options should be available, “office hours” being one of them
9.	When the student pushes the “office hours” option, the system must display the office hours schedule with varios options to view the schedule (day by day, week by week…)

## Responsabilities

# Login and validation responsibilities:
-	The system must ensure that the user which is login is a student

# Searching system responsibilities (technnical responsabilities):
-	The system must have all the information related to the teacher in its database.
-	The data base must be actualized to provide the latest information.
-	The system must be capable of searching the required teacher in the database.
-	The system must be able to load to the presentation layer the information of the database requested.
-   The system should be able to apply the desired filters to accotate the search of teachers
-
# Display of info responsibilities (Presentation layer responsabilities):
-	The system must display the “teachers” button in the main menu
-	The system must display all possible filters in the research menu
-	The system must display all the requested teachers in the research menu.
-	The system must display the teachers’ information in the teacher page, along with the links to other sections
-	The system must provide links to minor specific information.
-	The system must display the schedule of the office hours in many different ways.

## Auxiliar Feature: Viewing the teacher info – General information (student)
As a student, I want to have the general information (e-mail, phone, office place…) at hand.
## Auxiliar Feature: Viewing the student info – General information (anyone)
As a system user, I want to have the general information (e-mail, course, photo) of every student registered in the system
## Auxiliar Feature: Viewing the student info – Specific information (teacher)
As a teacher, I want to have the specific information (ID number, grading, assigned tutor…) of the students registered in the system.
## Auxiliar Feature: Viewing the teacher info – General Information (anyone)
As a system user, I want to have the general information (e-mail, course, photo) of every teacher registered in the system



### Feature: Viewing the room info

As a student, I want to see details about a classroom(location, capacity).

As a teacher or scheduling committee, I want to view room's availability and capacity, so I can plan and schedule courses.


#### Feature breakdown

1. User accesses the room information, from a list of rooms in a building or from a room link in a course description.
2. System displays the room's details(building, capacity, type, floor).
3. System shows a list of courses taking place in this room.
4. Calendar view shows the room's schedule.
5. Schedule comittee have a functionality to book the room for a specific time slot.


#### Responsibilities

##### Room information responsibilities
* Retrieve room data from the database.
* Fetch and provide the room's booking schedule.
* Cache frequently accessed room data.
* Validate schedule view data with the database.
* Provide API for other systems(for example enrollments) to query room availability and capacity.

##### Security responsibilities
* Control access to sensitive information and room booking functionality based on user title.
* Log view access, number of students in each room and how many courses per day are in each room for auditing and statistics.

##### Presentation responsibilities
* Display room details in a structured way.
* Display the room's schedule in a weekly calendar format.
* Search and filter functionality to find rooms based on capacity or availability.
* Ensure data integrity with the database.


### Feature: Schedule modification

As a teacher, I want to be able to change the classroom and the time at the Schedule if its neccesary, and the Student should be notified by this.

As a schedulling committee, I want to be able to modify the schedule to resolve potential conflicts between the courses.

#### Feature breakdown

1. User selects a specific course in the schedule.
2. User sends a modification request to the system.
3. System opens an editing interface for the user.
4. System analyzes the proposed change for conflicts with the teacher's or the room's schedules.
5. If there is a conflict, system displays an error.
6. If there is no conflict, user confirms the change and it is applied.
7. System updates the timetable in the database.
8. System sends a notification to all enrolled students about the change.


#### Responsibilities

#### Login and validation responsibilities
* Authorize the user which performs the modification, either teacher or scheduling committee.
* Validate the modification to prevent conflicts with relevant schedules of rooms and teachers.


##### Modification user interface responsibilities
* Provide an interface for selecting and editing a schedule.
* Suggest available rooms and time slots.
* Allow users to provide a comment to the schedule modification.
* Provide a preview of the schedule with the changes, before the final confirmation.


##### Notification responsibilities
* Identify all users that are affected by the modification of the schedule.
* Generate and send notifications using each student's email.
* Log any notification issues.

##### Data management responsibilities
* Execute schedule update as a database transaction
* Provide audit log of all changes.
* Implement a concurrency control to prevent data corruption, when multiple users attempt to modify the same schedule.


### Feature: Creating timetable

As the committee, I should receive all the teachers' preferences and with that information be able to plan all the lectures.

#### Feature Breakdown
0. The committee member logs into the system and opens the timetable management interface.
1. The system loads all registered teachers along with their submitted preferences — such as preferred time slots, assigned courses, and unavailable periods.
2. The system checks whether all teachers have submitted their preferences. If any data is missing, the committee is notified.
3. Once all data is available, the committee triggers the Generate Timetable action.
4. The system runs a scheduling algorithm that tries to fit all lectures into available time slots while respecting preferences and constraints (e.g., classroom capacities, overlapping courses, etc.).
5. The system highlights any unresolved conflicts or lectures that couldn’t be assigned automatically.
6. The committee can manually adjust the proposed schedule (for example, swapping time slots or assigning rooms).
7. When the timetable is finalized, the system saves the plan in the database.
8. Notifications are sent to teachers and students informing them that the new timetable has been published.

#### Responsibilities

##### Business Responsibilities
* Gather and validate all teachers’ preferences.
* Generate an initial timetable proposal using scheduling constraints.
* Allow the committee to review and adjust the proposed timetable manually.
* Approve and publish the final version of the timetable.
* Notify all relevant parties about timetable updates.

##### Technical Responsibilities
* Store and manage teacher preferences and timetable data in the system database.
* Execute and optimize the scheduling algorithm.
* Manage user roles and permissions (e.g., only the committee can modify timetables).
* Record changes and actions for audit purposes.
* Handle data synchronization if multiple committee members edit the timetable simultaneously.


##### Quality Responsibilities
* Ensure timetable data integrity during creation and editing.
* Maintain acceptable performance for the scheduling algorithm (avoid long computation times).
* Log generation errors or failures for debugging and recovery.
* Provide clear feedback in the UI when constraints are violated or conflicts remain.

## Auxiliary features and responsibilities

### Feature : Conflict Notification

As a student, I want the system to show me any schedule conflicts in my registered courses and suggest the best possible arrangement, but I should only be able to view the conflicts, not change the timetable.

### Feature Breakdown
0. The student logs into the system and opens their personal timetable view.
1. The system retrieves the student’s enrolled courses and the corresponding timetable from the database.
2. The system automatically checks for overlapping lectures, time clashes, or room conflicts.
3. If conflicts exist, the system visually highlights them (e.g., by coloring the conflicting time slots in red).
4. The system suggests possible alternative combinations or scenarios where conflicts could be resolved (for informational purposes only).
5. The student can review these suggestions but cannot make any direct modifications.
6. Optionally, the student can report a detected issue or conflict to the committee for further review.

#### Responsibilities
##### Business Responsibilities
* Analyze the student’s course schedule to identify conflicts.
* Present detected conflicts clearly within the timetable view.
* Suggest possible conflict-free alternatives for reference.
* Allow students to report timetable issues to the committee.


##### Technical Responsibilities
* Implement an efficient conflict detection algorithm based on lecture times and enrollments.
* Retrieve and correlate timetable and enrollment data from the database.
* Enforce read-only permissions for students (prevent edits).
* Log detected conflicts for analytics and future optimization.


##### Quality Responsibilities
* Ensure accuracy in detecting and displaying timetable conflicts.
* Maintain quick response times for conflict detection even with large datasets.
* Safeguard the privacy of student data and schedules.
* Provide an intuitive and non-intrusive UI for viewing conflicts.



### Fearure: Teacher Preference
As a teacher, I have a lot of lectures over the week which I need to reach so I should be able to tell the committee my personal preferences and the best schedule so they have them into account when they do the planning.
## Feature Breakdown (capabilities → key behaviors)
# Profile & Availability
o	Should be able to efine weekly availability windows
o	Should be able to mark blackout dates/periods (leave days, conferences, etc)
o	Should be able to set preferred days/times and campuses/rooms
o	SShoud be able to state equipment needs and room constraints
# Load & Spacing Rules
o	Should be able to see max daily/weekly teaching load
o	Should be able to see min gap between classes
# Versioning & Lifecycle
o	Should be to save as draft ↔ Submit ↔ Review/Approve ↔ Lock for term
o	Should be to see preferences from previous terms
# Validation & Guidance
o	Detect overlaps/impossible rules
o
o
# Audit & Privacy
o	Track changes and approvals
o	Role-scoped visibility (Teacher, Scheduler, Admin)
## System Responsibilities
# Presentation/UI
•	Render weekly grid editor (availability/blackouts/preferred)
•	Course/section ranking widgets; hard/soft toggles with weights
•	Status banners (draft/submitted/approved/locked) and deadline warnings
•   Provide human-readable, actionable error messages
# Application/Business
•	Retreive teacher weekly schedule elements (availability, blackouts, etc)
•	Enforce transitions and deadlines (semesters, etc)
•	Do policy checks on draft schedules when attempting to save (e.g., minimum presence windows, maximum number of classes per day/week, etc)
•	Aggregate feedback into per-teacher satisfaction scores
# Persistence
•	Store preferences per teacher per term; time windows
•	Track reviews/approvals with timestamps and actors
•	Keep immutable audit log (before/after diffs or event log)
•	Persist version history; support clone-from-previous-term
# Non-functional
•	Strong input validation
•	Access logging and retention aligned with institutional policy


### Feature: Statistical Reports
## Feature Breakdown (capabilities → key behaviors)
# Resource Utilization
o	Should be able to view room utilization by hour/day/building/term
o	Should be able to view equipment usage saturation
o	Should be able to view teacher time utilization
# Exploration & Exports
o	Should be able to apply filters to the schedule (term, program, department, campus, teacher, room)
o	Should be able to drill-down from KPI → offending assignments → suggested fixes
o	Shoud be able to perform scheduled exports (CSV/XLSX) and snapshotting for comparisons

## System Responsibilities
# Presentation/UI
•	Show KPI tiles (at-a-glance), traffic-light status (green/amber/red)
•	show Room/slot heatmaps; trend charts; sortable violation tables
•	Show quick filters and saved views; export buttons
•	Show a comparison view (current vs previous version/term)
# Application/Business
•	Compute KPI progress statistics
•	Compute room usage statistics
•	Filter data according to user input
•	Export statistics page to various formats (pdf, excel, word)
•	Compute comparisons between current and previous terms
# Persistence
•	Retrieve  teacher perfomance data from the database
•	Retrieve room usage data from the database
•	Retrieve teacher performance data from previous and current term
•	Filter data according to user input
# Integration
•	Optional hooks to BI tools (read-only)



### Feature: Viewing the timetable (teacher)

As a teacher, I want to be able to see my timetable s.t. I know when and where the courses take place, and be able to perform scheduling, and also manage my preferences


### Feature: Viewing the timetable (scheduling committee)

As a scheduling committee, I want to be able the timetable for all courses taking place s.t. I know when and where the courses take place, and be able to perform scheduling


### Feature: Viewing the timetable (manager)

As a manager, I want to be able to see my timetable s.t. I know when and where the courses take place


### Feature: Viewing the course info (teacher)

As a teacher, I want to see the course info s.t. I know the course's details, and be able to manage them


### Feature: Viewing the course info (scheduling committee)

As a scheduling committee, I want to see the course info s.t. I know the course's details


### Feature: Viewing the course info (manager)

As a manager, I want to see the course info s.t. I know the course's details
