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