workspace "University Scheduling Workspace" "Architecture of the University Scheduling System focusing on Room Info and Schedule Modification." {

    model {
        student = person "Student" "Views timetables and searches for rooms."
        teacher = person "Teacher" "Manages schedule preferences and modifies lectures."
        committee = person "Scheduling Committee" "Resolves conflicts and finalizes timetables."
        
        emailProvider = softwareSystem "Email Provider" "External system for sending notifications." "Existing System"

        schedulingSystem = softwareSystem "University Scheduling System" "Manages timetables, rooms, and schedule modifications." {
            webFrontend = container "Web Frontend" "Delivers the UI for students and teachers." "React/Vue SPA" "Web Front-End" {
                roomViewer = component "Room Viewer" "UI for displaying room details and schedules"
                roomSearchUI = component "Room Search UI" "UI for filtering rooms by capacity/type"
                scheduleEditor = component "Schedule Editor" "UI for modifying time slots"
                conflictAlertUI = component "Conflict Alert UI" "UI for displaying validation errors"
            }
            roomService = container "Room Management Service" "Manages room data, availability, and capacity." "Java/Spring" {
                roomController = component "Room Controller" "Exposes REST endpoints for room details"
                roomFinder = component "Room Finder" "Implements search logic and filtering (capacity, building)"
                availabilityCalculator = component "Availability Calculator" "Merges room static data with schedule events"
                accessLogger = component "Access Logger" "Logs views and search patterns for statistics"
                roomRepository = component "Room Repository" "Abstracts database access for room entities"
                roomCacheManager = component "Room Cache Manager" "Manages caching of static room details"
            }
            scheduleEngine = container "Scheduling Engine" "Handles schedule modifications and conflict detection." "Java/Spring" {
                modController = component "Modification Controller" "Receives modification requests"
                workflowManager = component "Modification Workflow Manager" "Orchestrates validation, locking, and persistence"
                conflictValidator = component "Conflict Validator" "Checks overlaps, room capacity, and constraints"
                suggestionEngine = component "Suggestion Engine" "Finds alternative rooms or time slots"
                concurrencyManager = component "Concurrency Manager" "Handles record locking/versioning"
                impactAnalyzer = component "Impact Analyzer" "Identifies users affected by a change"
                scheduleRepository = component "Schedule Repository" "Persists timetable changes"
            }
            db = container "Main Database" "Stores schedules, rooms, and users." "PostgreSQL" "Database"
            cache = container "Cache" "Stores frequently accessed data." "Redis" "Database"

        }


        student -> webFrontend "Views timetable data via"
        teacher -> webFrontend "Interacts with schedule dashboard via"
        
        teacher -> scheduleEditor "Inputs new time slot parameters into"

        webFrontend -> roomController "Requests room details (JSON) via HTTPS"
        roomViewer -> roomController "Fetches room schedule via API"
        roomSearchUI -> roomController "Sends search criteria (capacity/type) to"
        
        webFrontend -> modController "POSTs modification requests via HTTPS"
        scheduleEditor -> modController "Sends JSON payload with new slot details to"

        roomController -> roomFinder "Delegates filtering logic to"
        roomController -> availabilityCalculator "Requests free/busy status from"
        roomController -> accessLogger "Sends view event metadata to"
        
        roomFinder -> roomRepository "Selects room entities from"
        roomFinder -> roomCacheManager "Retrieves cached room lists from"
        
        availabilityCalculator -> roomRepository "Fetches existing booking records from"
        availabilityCalculator -> roomCacheManager "Gets static capacity limits from"
        
        roomRepository -> db "Executes SQL SELECT/JOIN on Room tables"
        roomCacheManager -> cache "Reads/Writes serialized room objects"

        modController -> workflowManager "Initiates change transaction in"
        
        workflowManager -> conflictValidator "Requests conflict check for new slot"
        workflowManager -> concurrencyManager "Acquires optimistic lock via"
        workflowManager -> scheduleRepository "Persists validated schedule update to"
        workflowManager -> impactAnalyzer "Requests list of enrolled students from"
        
        conflictValidator -> scheduleRepository "Reads occupied slots for validation"
        suggestionEngine -> scheduleRepository "Scans for empty time slots in"
        
        scheduleRepository -> db "Executes SQL INSERT/UPDATE on Schedule tables"
        
        impactAnalyzer -> emailProvider "Triggers SMTP notification via"
    }

    views {
        
        systemContext schedulingSystem "SystemContext" {
            include *
            autolayout lr
        }

        container schedulingSystem "ContainerView" {
            include *
            autolayout tb
        }

        component roomService "RoomServiceComponentView" {
            include *
            autolayout tb
        }

        component scheduleEngine "ScheduleEngineComponentView" {
            include *
            autolayout tb
        }

        dynamic scheduleEngine "ScheduleModificationFlow" "A teacher modifies a course time slot" {
            teacher -> scheduleEditor "Selects new time"
            scheduleEditor -> modController "POSTs change request"
            modController -> workflowManager "Orchestrates change"
            workflowManager -> conflictValidator "Validates overlaps"
            conflictValidator -> scheduleRepository "Fetches existing slots"
            workflowManager -> concurrencyManager "Acquires lock"
            workflowManager -> scheduleRepository "Saves new slot"
            scheduleRepository -> db "Commits transaction"
            workflowManager -> impactAnalyzer "Identifies affected students"
            impactAnalyzer -> emailProvider "Queues notification email"
            
            autolayout lr
        }

        theme default

        styles {
            element "Person" {
                background #08427b
                color #ffffff
                shape Person
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            
            element "Component" {
                background #85bbf0 
                color #000000
                shape Box
            }

            element "Database" {
                shape Cylinder
                background #2f71ab
                color #ffffff
            }

            element "Web Front-End" {
                shape Box
                background #85bbf0
                color #000000
            }

            element "Existing System" {
                background #999999
                color #ffffff
            }
        }
    }
}