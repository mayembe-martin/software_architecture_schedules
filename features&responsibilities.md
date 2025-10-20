# Schedule System

## Core features and responsibilities

### Feature: Viewing the timetable (student)

As a student, I want to be able to see my timetable s.t. I know when and where the courses take place

#### Feature breakdown

0. Login
1. Anyone can open the Timetable page
2. The timetable for the current week is shown (which the student is enrolled to)
3. If a course button is pressed in the schedule, a course detail page is opened ('Viewing the course info' feature)
4. If the 'Whole year' button is pressed, the schedule for the whole year is shown

#### Responsibilities

##### Timetable info responsibilities
* Load the timetable info (based on who is viewing this)
* Cache

##### Course info responsibilities
* Load the course info
* Cache



### Feature: Viewing the course info (student)

As a student/manager, I want to see the course info s.t. I know the course's details

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


### Feature: Schedule modification

As a teacher, I want to be able to change the classroom and the time at the Schedule if its neccesary, and the Student should be notified by this.


### Feature: Creating timetable

As the committee, I should receive all the teachers' preferences and with that information be able plan all the lectures.



## Auxiliary features and responsibilities

### Feature: Conflict notification

As an student, I want the system to give me the best combination or scenario to have all the Schedule well fitted. (But the Student could only be able to see the conflicts, not modify them)


### Feature: Teacher preference

As a teacher, I have a lot of lectures over the week which i need to reach so I should be able to tell the committee my personal prefereces and the best schedule so they have them into account when they do the planning.


### Feature: Statistical reports

As a manager, I want to see the data of the system, the reports of its use and another funcionalities.


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