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

As the committee, I should receive all the teachers' preferences and with that information be able plan all the lectures.



## Auxiliary features and responsibilities

### Feature: Conflict notification

As an student, I want the system to give me the best combination or scenario to have all the Schedule well fitted. (But the Student could only be able to see the conflicts, not modify them)


### Feature: Teacher preference

As a teacher, I have a lot of lectures over the week which i need to reach so I should be able to tell the committee my personal prefereces and the best schedule so they have them into account when they do the planning.


### Feature: Statistical reports

As a manager, I want to see the data of the system, the reports of its use and another funcionalities.
