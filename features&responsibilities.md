# Schedule System

## Core features and responsibilities

### Feature: Viewing the timetable

As a student/manager, I want to be able to see my timetable s.t. I know when and where the courses take place

As a teacher, I want to be able to see my timetable s.t. I know when and where the courses take place, and be able to perform scheduling, and also manage my preferences

As a scheduling committee, I want to be able the timetable for all courses taking place s.t. I know when and where the courses take place, and be able to perform scheduling

#### Feature breakdown

0. Login
1. Anyone can open the Timetable page
2. The schedule for the current week is shown
3. If a course button is pressed in the schedule, a course detail page is opened ('Viewing the course info' feature)
4. If the 'Whole year' button is pressed, the schedule for the whole year is shown

#### Responsibilities

##### Schedule info responsibilities
* Load the schedule info
* Cache

##### Course info responsibilities
* Load the course info
* Cache



### Feature: Viewing the course info

As a student/scheduling committee/manager, I want to see the course info s.t. I know the course's details

As a teacher, I want to see the course info s.t. I know the course's details, and be able to manage them

#### Feature breakdown

0. Anyone can view the course's details on the page
1. A teacher can also press the 'Edit' button to open the new page where the course's info can be managed ('Course management' feature)

#### Responsibilities

##### Course editing responsibilities
* Provide an edit form
* Save the new info in the database



### Feature: Viewing the teacher info
eñrihfbwñrfvb

### Feature: Viewing the student info




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


### Feature: Teacher preference

As a teacher, I have a lot of lectures over the week which i need to reach so I should be able to tell the committee my personal prefereces and the best schedule so they have them into account when they do the planning.


### Feature: Statistical reports

As a manager, I want to see the data of the system, the reports of its use and another funcionalities.



