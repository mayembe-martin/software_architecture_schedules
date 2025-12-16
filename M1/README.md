# Software Systems Architectures Schedules1

In this README is defined the description of the entire system of schedule that our team has designed and the organization of this repository.

## INDEX

- Presentation_M1.pptx -- Presentation used in the first part of the proyect's presentation
- C4.dsl -- C4 model with L1,L2, each Feature L3 & Deployment Diagrams
- FeaturesToModules.drawio
- Features&Responsabilities.md - Features and Responsabilities BreakDown/First aproach to the proyect architecture
- Features (folder): Folder with each Feature L3 diagram
    - scheduleEngine_roomInfo.dsl
    - statistics.dsl
    - viewingcourseinfo.dsl
    - viewingTimetabel.dsl
    - officeHours.dsl


## HOW TO UNDERSTAND THE SYSTEM DESIGN

To make the design of all the system of scheduling, our team followed three main steps or architecture types:

1. features&responsabilities.md file. Here, our team braimstormed all the features that we wanted in the system to be implemented, and we divided in two types: Core features and Auxiliar features. 
    The Core features are the basis of the system. As a core features, we fully breakdown them with the proccess that the system should follow in order to achieve them, with a list of responsabilities that each feature fulfills. We decided to make a Core feature for each member of the team:
        - Teacher info with Office Hours display
        - Viewing Room info
        - Stadistics Report
        - Viewing TimeTable
        - Viewing course Info
    
    The auxiliar features are those features that are not esential for the system to be implemented, and because of that there is only an explanation of their function

2. FeatureToModules.drawio file. Here, the core features that were broken down in the features&responsabilities file are put in a Layered architecture, divided in 3 main layers: Presentation, Businness and Technnical. In this architecture, the responsabilities are placed in one of these 3 layers, and modules are created based on the closeness and connection between responsabilities.

3. C4.dsl file. This file sums up the C4 design of all the system, including the L1, L2 & each features' L3 diagrams, along with the deployment diagrams.

    - L1 diagram: L1 diagram shows the archictecture of the system in a very general way, with only the actors and the system which are taking part, along with external or auxiliar systems. 
    
    In the C4.dsl file, if it is run in the Structurizr Software, it can be found in the slot "System Context View: University Scheduling System"


    - L2 diagram: L2 diagram shows how the system is builded in a high level of abstraction. In this diagram, the containers that form the system and the interactions between them are displayed. 

    In the C4.dsl file, it can be found in the slot "Container View: University Scheduling System"


L3 diagrams: Each L3 diagram breaks down a feature container into its internal components, organized across architectural layers.

1. **Timetable Viewer:**
   - **Presentation Layer:** Displays timetables in two different views - current week and whole year formats that users can switch between
   - **Business Logic:** Handles requests for timetable data for each view type and manages navigation when users click on course slots to view detailed information
   - **Persistence Layer:** Manages database access to retrieve timetable information
   - *Total: 6 components showing how students view their schedules with flexible viewing options and easy navigation to course details*

2. **Course Information Service:**
   - **Business Logic:** Orchestrates the retrieval of comprehensive course information by coordinating multiple data sources - validates user permissions, searches for courses, aggregates data from instructor/schedule/enrollment/prerequisite services, manages exam dates and computes course statistics
   - **Persistence Layer:** Queries databases for course metadata, instructor details, and schedule information while using cache to improve performance and logging all access events for security
   - *Total: 15 components that assemble complete course information from multiple data sources, ensuring students see accurate details about courses, prerequisites, enrollment capacity, and scheduling*

3. **Teacher Information Service:**
   - **Teacher Management:** Handles teacher search requests, displays office hours, manages teacher profiles, and validates user permissions
   - **Office Hours Backend:** Complex system that authenticates users, validates search filters, retrieves and formats office hour slots with recurrence patterns, caches results for performance, and can trigger notifications when schedules change
   - **Persistence:** Abstracts database access for teacher and schedule data
   - **Notification:** Queues and processes email notifications and calendar sync events
   - *Total: 21 components providing a complete teacher information system with sophisticated office hours management, smart caching to reduce database load, and automated notifications*

4. **Schedule Modification Service:**
   - **Modification Management:** Receives schedule change requests, orchestrates a validation workflow, checks for conflicts (time overlaps, room capacity), suggests alternative slots when conflicts exist, and enforces user permissions
   - **Concurrency & Impact:** Handles record locking to prevent simultaneous conflicting changes and identifies which students/teachers are affected by schedule modifications
   - **Persistence:** Persists validated timetable changes to the database
   - *Total: 9 components ensuring schedule changes are validated, conflict-free, properly authorized, and that affected users are identified for notification*

5. **Statistical Reports Service:**
   - **Presentation:** Dashboard UI displaying KPIs, heatmaps, trend charts with filter options and export buttons
   - **Business Logic:** Pre-aggregates metrics for fast dashboard loading and formats data for CSV/XLSX exports
   - **Infrastructure:** Caches frequently accessed statistics to reduce database queries, logs all user searches and report requests for audit purposes, and connects to both internal database and external enrollment system
   - *Total: 5 components generating resource utilization analytics and reports with intelligent caching and comprehensive audit logging for compliance*

---

**Dynamic Diagram - Timetable Viewer Flow:**
Shows the complete user journey: student views current week timetable → system retrieves data from database → displays timetable → student clicks on a course → system redirects to detailed course information page. This demonstrates how the Timetable Viewer and Course Information Service work together.
