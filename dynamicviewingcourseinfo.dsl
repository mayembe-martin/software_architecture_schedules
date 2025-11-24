workspace "Course Information Display - Multi-Level Views" "Container and Component views for the Course Information Display subsystem" {
  model {
    # External users
    student = person "Student" "Views course details, schedules, and enrollment information"
    academicAdvisor = person "Academic Advisor" "Assists students with course selection and planning"
    instructor = person "Instructor" "Views their assigned courses and student enrollment"
    
    # External systems/containers
    timetableService = softwareSystem "Timetable Service" "Manages course schedules and timeslots"
    courseManagementService = softwareSystem "Course Management Service" "Manages course catalog and metadata"
    instructorService = softwareSystem "Teacher Information Service" "Manages instructor profiles and assignments"
    enrollmentService = softwareSystem "Enrollment Service" "Manages student registrations and capacity"
    prerequisiteService = softwareSystem "Prerequisite Validation Service" "Validates course prerequisites"
    roomBookingService = softwareSystem "Room Information Service" "Provides classroom location data"
    authenticationService = softwareSystem "Authentication Service" "Handles user authentication and authorization"
    
    # The Course Information Display System (your feature)
    courseInfoSystem = softwareSystem "Course Information Display" "Provides detailed course information, schedules, prerequisites, and enrollment status" {
      
      # Level 2: Containers
      ui = container "Presentation/UI" "Displays course details, instructor info, schedules, prerequisites, capacity, and credits" "Web UI (React/Angular)" {
        # Level 3: UI Components
        courseDetailsView = component "Course Details View" "Displays course name, code, type, semester, and academic year" "React Component"
        instructorInfoView = component "Instructor Info View" "Shows instructor name, contact info, office hours, and profile link" "React Component"
        scheduleView = component "Schedule View" "Renders weekly timeslots, room location, duration, and frequency" "React Component"
        prerequisitesView = component "Prerequisites View" "Lists required courses and displays prerequisite fulfillment status" "React Component"
        capacityView = component "Capacity/Enrollment View" "Shows max capacity, enrolled students, and seat availability" "React Component"
        descriptionView = component "Description View" "Displays course description, learning outcomes, and topics covered" "React Component"
        creditsView = component "Credits View" "Shows ECTS/credit value and workload expectations" "React Component"
      }
      
      application = container "Application/Business Logic" "Assembles course information, validates permissions, and coordinates data retrieval" "Backend Service (Java/Python/Node)" {
        # Level 3: Application Components
        courseService = component "Course Service" "Fetches core course details and coordinates all sub-services" "Service Class"
        courseFinder = component "Course Finder / Catalog" "Searches for courses by ID and validates course existence" "Service Class"
        permissionService = component "Permission Service" "Validates student view permissions and enrollment status" "Service Class"
        courseAggregator = component "Course Aggregator" "Merges instructor, schedule, capacity, prerequisites, and metadata into unified response" "Service Class"
        instructorDataService = component "Instructor Data Service" "Retrieves instructor information for assigned courses" "Service Class"
        scheduleDataService = component "Schedule Data Service" "Retrieves timeslot and room information" "Service Class"
        prerequisiteChecker = component "Prerequisite Checker" "Validates prerequisite fulfillment for students" "Service Class"
        enrollmentDataService = component "Enrollment Data Service" "Retrieves capacity and current enrollment data" "Service Class"
      }
      
      persistence = container "Persistence Layer" "Data retrieval, caching, and audit logging" "DB + Cache + Logging" {
        # Level 3: Persistence Components
        courseRepository = component "Course Repository" "Queries course metadata, description, credits, and prerequisites" "Repository"
        instructorRepository = component "Instructor Repository" "Queries instructor details and contact information" "Repository"
        scheduleRepository = component "Schedule Repository" "Queries weekly timeslots, room info, and calendar alignment" "Repository"
        cacheManager = component "Cache Manager" "Caches frequently accessed course metadata, instructor info, and schedules" "Cache Service"
        accessLogger = component "Access Logger" "Logs course-info view events and permission violations" "Logging Service"
      }
      
      db = container "Database" "Stores course metadata, schedules, instructor assignments, and enrollment data" "PostgreSQL/MySQL"
      cache = container "Cache" "Caches frequently accessed course information for faster responses" "Redis"
      audit = container "Audit Logger" "Stores user access history and course view events" "Logging Service (ELK/Cloud)"
    }
    
    # Level 2: Internal relationships within Course Information Display
    ui -> application "Sends course lookup requests and filter criteria"
    application -> persistence "Requests data retrieval, reads/writes cached data, logs access events"
    persistence -> db "Reads course, instructor, schedule, and enrollment data"
    persistence -> cache "Reads from and writes to cache"
    persistence -> audit "Writes audit events (course views, access patterns)"
    
    # Level 3: UI Component relationships
    courseDetailsView -> courseService "Requests core course details"
    instructorInfoView -> courseService "Requests instructor information"
    scheduleView -> courseService "Requests schedule and room data"
    prerequisitesView -> courseService "Requests prerequisite information and validation status"
    capacityView -> courseService "Requests enrollment and capacity data"
    descriptionView -> courseService "Requests course description and outcomes"
    creditsView -> courseService "Requests credit value and workload info"
    
    # Level 3: Application Component relationships
    courseService -> courseFinder "Validates course existence and retrieves course ID"
    courseService -> permissionService "Validates user access permissions"
    courseService -> courseAggregator "Requests fully assembled course data"
    
    courseFinder -> courseRepository "Queries course by ID"
    courseFinder -> cacheManager "Checks cache for course lookup"
    
    permissionService -> accessLogger "Logs permission checks and violations"
    
    courseAggregator -> instructorDataService "Fetches instructor data"
    courseAggregator -> scheduleDataService "Fetches schedule data"
    courseAggregator -> enrollmentDataService "Fetches capacity and enrollment data"
    courseAggregator -> prerequisiteChecker "Fetches and validates prerequisites"
    courseAggregator -> courseRepository "Fetches course metadata and description"
    
    instructorDataService -> instructorRepository "Queries instructor details"
    instructorDataService -> cacheManager "Reads/writes cached instructor info"
    
    scheduleDataService -> scheduleRepository "Queries timeslots and room info"
    scheduleDataService -> cacheManager "Reads/writes cached schedule data"
    
    prerequisiteChecker -> courseRepository "Queries prerequisite list"
    prerequisiteChecker -> permissionService "Validates prerequisite visibility"
    
    enrollmentDataService -> courseRepository "Queries capacity and enrollment status"
    enrollmentDataService -> cacheManager "Reads/writes cached enrollment data"
    
    # Level 3: Persistence Component relationships
    courseRepository -> db "Executes SQL queries for course metadata, prerequisites, credits"
    courseRepository -> accessLogger "Logs course data access"
    
    instructorRepository -> db "Executes SQL queries for instructor information"
    instructorRepository -> accessLogger "Logs instructor data access"
    
    scheduleRepository -> db "Executes SQL queries for schedule and room data"
    scheduleRepository -> accessLogger "Logs schedule data access"
    
    cacheManager -> cache "Reads and writes cached course information"
    
    accessLogger -> audit "Writes access logs and view events"
    
    # User interactions
    student -> ui "Views course details, schedules, prerequisites, and enrollment status"
    academicAdvisor -> ui "Assists students by viewing course information and availability"
    instructor -> ui "Views their assigned courses and enrollment numbers"
    
    # External system interactions (data exchange)
    application -> timetableService "Pulls course schedule and timeslot data"
    application -> courseManagementService "Pulls course catalog and metadata"
    application -> instructorService "Pulls instructor profiles and contact information"
    application -> enrollmentService "Pulls enrollment status and capacity data"
    application -> prerequisiteService "Validates prerequisite fulfillment for students"
    application -> roomBookingService "Pulls classroom location and room details"
    application -> authenticationService "Validates user identity and permissions"
  }
  
  views {
    systemContext courseInfoSystem "SystemContext" "System context showing Course Information Display and external interactions" {
      include *
      autolayout lr
    }
    
    container courseInfoSystem "ContainerView" "Level 2: Container-level view for Course Information Display" {
      include *
      autolayout tb
    }
    
    component ui "ComponentView-UI" "Level 3: UI Components within Presentation Layer" {
      include *
      autolayout tb
    }
    
    component application "ComponentView-Application" "Level 3: Application Components within Business Logic Layer" {
      include *
      autolayout tb
    }
    
    component persistence "ComponentView-Persistence" "Level 3: Persistence Components within Data Access Layer" {
      include *
      autolayout tb
    }
    
    # Dynamic Diagrams - showing interaction flows at different levels
    
    # Container-level dynamic views (L2)
    dynamic courseInfoSystem "StudentViewsCourse" "Flow when a student views course details" {
      student -> ui "1. Requests course COMP101 details"
      ui -> application "2. getCourseDetails(courseId: COMP101, userId: student123)"
      application -> persistence "3. Queries course, instructor, and schedule data"
      persistence -> cache "4. Checks cache for course data"
      persistence -> db "5. Queries database (if cache miss)"
      persistence -> application "6. Returns assembled course data"
      application -> ui "7. Returns complete course information"
      ui -> student "8. Displays course details, schedule, prerequisites, etc."
      persistence -> audit "9. Logs course view event"
      autolayout lr
    }
    
    dynamic courseInfoSystem "CachedDataRetrieval" "Optimized flow when course data is cached" {
      student -> ui "1. Views course schedule"
      ui -> application "2. getCourseSchedule(COMP101)"
      application -> persistence "3. Requests schedule data"
      persistence -> cache "4. GET course:COMP101 (cache hit)"
      persistence -> application "5. Returns cached data"
      application -> ui "6. Returns schedule information"
      ui -> student "7. Displays timeslots and room locations"
      persistence -> audit "8. Logs quick retrieval"
      autolayout lr
    }
    
    # Component-level dynamic views (L3) - scoped to application container
    dynamic application "AggregateCourseData" "How application components aggregate course information" {
      courseService -> courseFinder "1. Validates course existence"
      courseFinder -> courseRepository "2. Queries course by ID"
      courseFinder -> cacheManager "3. Checks cache for course lookup"
      courseService -> permissionService "4. Validates user access permissions"
      permissionService -> accessLogger "5. Logs permission checks"
      courseService -> courseAggregator "6. Requests fully assembled course data"
      courseAggregator -> instructorDataService "7. Fetches instructor data"
      instructorDataService -> instructorRepository "8. Queries instructor details"
      instructorDataService -> cacheManager "9. Reads/writes cached instructor info"
      courseAggregator -> scheduleDataService "10. Fetches schedule data"
      scheduleDataService -> scheduleRepository "11. Queries timeslots and room info"
      scheduleDataService -> cacheManager "12. Reads/writes cached schedule data"
      courseAggregator -> prerequisiteChecker "13. Fetches and validates prerequisites"
      prerequisiteChecker -> courseRepository "14. Queries prerequisite list"
      prerequisiteChecker -> permissionService "15. Validates prerequisite visibility"
      courseAggregator -> enrollmentDataService "16. Fetches capacity and enrollment data"
      enrollmentDataService -> courseRepository "17. Queries capacity and enrollment status"
      enrollmentDataService -> cacheManager "18. Reads/writes cached enrollment data"
      courseAggregator -> courseRepository "19. Fetches course metadata and description"
      autolayout lr
    }
    
    dynamic application "CachingStrategy" "How caching is managed in application layer" {
      courseFinder -> cacheManager "1. Checks cache for course lookup"
      instructorDataService -> cacheManager "2. Reads/writes cached instructor info"
      scheduleDataService -> cacheManager "3. Reads/writes cached schedule data"
      enrollmentDataService -> cacheManager "4. Reads/writes cached enrollment data"
      autolayout lr
    }
    
    # Component-level dynamic view (L3) - scoped to persistence container
    dynamic persistence "PersistenceDataAccess" "How persistence components access database and log events" {
      courseRepository -> db "1. Queries course metadata and prerequisites"
      courseRepository -> accessLogger "2. Logs course data access"
      instructorRepository -> db "3. Queries instructor information"
      instructorRepository -> accessLogger "4. Logs instructor data access"
      scheduleRepository -> db "5. Queries schedule and room data"
      scheduleRepository -> accessLogger "6. Logs schedule data access"
      cacheManager -> cache "7. Reads and writes cached results"
      accessLogger -> audit "8. Writes all access logs to audit system"
      autolayout lr
    }
    
    styles {
      element "Person" {
        shape Person
        background "#08427b"
        color "#ffffff"
      }
      element "Software System" {
        background "#1168bd"
        color "#ffffff"
      }
      element "Container" {
        background "#438dd5"
        color "#ffffff"
      }
      element "Component" {
        background "#85bbf0"
        color "#000000"
      }
      element "Database" {
        shape Cylinder
      }
    }
  }
}