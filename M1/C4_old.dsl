workspace "University Scheduling System" "A comprehensive university course scheduling and timetable management system" {

    model {
        # People
        student = person "Student" "Uses the platform to view timetables, course & teacher info"
        teacher = person "Teacher" "Views timetable, provides preferences, modifies schedule"
        schedulingCommittee = person "Scheduling Committee" "Creates timetables and resolves conflicts"
        managerAdmin = person "Manager / Admin" "Accesses overview and reports"

        # Software Systems
        universitySchedulingSystem = softwareSystem "University Scheduling System" "Manages timetables, rooms, preferences and notifications" {

            # Frontend Container
            webapp = container "Web Application" "Delivers scheduling functionality to users" "React / Angular" {
                tags "Web Browser"
            }

            # Feature-based Containers

            timetableViewingContainer = container "Timetable Viewing Service" "Handles timetable display for all user types (current week, whole year views)" "Spring Boot" {
              group "Presentation" {
                cwTimetableDisplay = component "Current week timetable display"
                wyTimetableDisplay = component "Whole year timetable display"
              }
              group "Business" {
                timetableInfoRequester = component "Timetable info requester"
                courseDetailRequester = component "Course detail page requester"
              }
              group "Persistence" {
                timetableDatabase = component "Timetable database"
              }
            }

            courseInfoContainer = container "Course Information Display" "Provides detailed course information, schedules, prerequisites, and enrollment status" "Spring Boot" {
                # UI Layer Components
                courseDetailsView = component "Course Details View" "Displays course name, code, type, semester, and academic year" "React Component"
                instructorInfoView = component "Instructor Info View" "Shows instructor name, contact info, office hours, and profile link" "React Component"
                scheduleView = component "Schedule View" "Renders weekly timeslots, room location, duration, and frequency" "React Component"
                prerequisitesView = component "Prerequisites View" "Lists required courses and displays prerequisite fulfillment status" "React Component"
                capacityView = component "Capacity/Enrollment View" "Shows max capacity, enrolled students, and seat availability" "React Component"
                descriptionView = component "Description View" "Displays course description, learning outcomes, and topics covered" "React Component"
                creditsView = component "Credits View" "Shows ECTS/credit value and workload expectations" "React Component"

                # Business Logic Layer Components
                courseService = component "Course Service" "Fetches core course details and coordinates all sub-services" "Service Class"
                courseFinder = component "Course Finder / Catalog" "Searches for courses by ID and validates course existence" "Service Class"
                permissionService = component "Permission Service" "Validates student view permissions and enrollment status" "Service Class"
                courseAggregator = component "Course Aggregator" "Merges instructor, schedule, capacity, prerequisites, and metadata into unified response" "Service Class"
                instructorDataService = component "Instructor Data Service" "Retrieves instructor information for assigned courses" "Service Class"
                scheduleDataService = component "Schedule Data Service" "Retrieves timeslot and room information" "Service Class"
                prerequisiteChecker = component "Prerequisite Checker" "Validates prerequisite fulfillment for students" "Service Class"
                enrollmentDataService = component "Enrollment Data Service" "Retrieves capacity and current enrollment data" "Service Class"

                # Persistence Layer Components
                courseRepository = component "Course Repository" "Queries course metadata, description, credits, and prerequisites" "Repository"
                instructorRepository = component "Instructor Repository" "Queries instructor details and contact information" "Repository"
                scheduleRepository = component "Schedule Repository" "Queries weekly timeslots, room info, and calendar alignment" "Repository"
                cacheManager = component "Cache Manager" "Caches frequently accessed course metadata, instructor info, and schedules" "Cache Service"
                accessLogger = component "Access Logger" "Logs course-info view events and permission violations" "Logging Service"
            }

            teacherInfoContainer = container "Teacher Information Service" "Manages teacher profiles, office hours, and availability" "Spring Boot" {
                teacherController = component "Teacher Controller" "Handles teacher information requests"
                teacherSearchService = component "Teacher Search Service" "Searches teachers by various criteria"
                officeHoursService = component "Office Hours Service" "Manages and displays teacher office hours"
                teacherProfileService = component "Teacher Profile Service" "Manages teacher profile information"
                validationService = component "Validation Service" "Validates user roles and input data"
            }

            roomInfoContainer = container "Room Information Service" "Manages room details, availability, and booking" "Spring Boot" {
                roomController = component "Room Controller" "Handles room information requests"
                roomDetailService = component "Room Detail Service" "Retrieves room details (location, capacity, type)"
                roomScheduleService = component "Room Schedule Service" "Manages room booking schedule"
                roomBookingService = component "Room Booking Service" "Handles room booking for scheduling committee"
                roomSearchService = component "Room Search Service" "Searches and filters rooms"
            }

            scheduleModificationContainer = container "Schedule Modification Service" "Handles schedule changes and conflict detection" "Spring Boot" {
                modificationController = component "Modification Controller" "Handles schedule modification requests"
                conflictDetectionService = component "Conflict Detection Service" "Analyzes schedule changes for conflicts"
                scheduleEditorService = component "Schedule Editor Service" "Manages schedule editing operations"
                authorizationService = component "Authorization Service" "Validates user permissions for modifications"
                suggestionEngine = component "Suggestion Engine" "Suggests available rooms and time slots"
            }

            timetableCreationContainer = container "Timetable Creation Service" "Handles automated and manual timetable generation" "Spring Boot" {
                creationController = component "Timetable Creation Controller" "Manages timetable creation workflow"
                preferenceCollector = component "Preference Collector" "Gathers teacher preferences"
                schedulingAlgorithm = component "Scheduling Algorithm" "Generates initial timetable proposal"
                manualAdjustmentService = component "Manual Adjustment Service" "Allows committee to manually adjust timetable"
                constraintValidator = component "Constraint Validator" "Validates scheduling constraints"
                timetablePublisher = component "Timetable Publisher" "Publishes finalized timetable"
            }

            conflictNotificationContainer = container "Conflict Notification Service" "Detects and displays schedule conflicts for students" "Spring Boot" {
                conflictController = component "Conflict Controller" "Handles conflict detection requests"
                conflictAnalyzer = component "Conflict Analyzer" "Identifies overlapping lectures and time clashes"
                alternativeGenerator = component "Alternative Generator" "Suggests conflict-free alternatives"
                issueReporter = component "Issue Reporter" "Allows students to report conflicts"
            }

            teacherPreferenceContainer = container "Teacher Preference Service" "Manages teacher scheduling preferences and constraints" "Spring Boot" {
                preferenceController = component "Preference Controller" "Handles teacher preference submissions"
                availabilityManager = component "Availability Manager" "Manages weekly availability and blackout dates"
                preferenceEditor = component "Preference Editor" "Provides interface for editing preferences"
                preferenceValidator = component "Preference Validator" "Validates preferences for conflicts and policies"
                versioningService = component "Versioning Service" "Manages preference versions and history"
                workflowEngine = component "Workflow Engine" "Manages draft/submit/approve lifecycle"
            }

            statisticsReportContainer = container "Statistical Reports Service" "Generates reports and analytics on resource utilization" "Spring Boot" {
                statisticsUI = component "Statistics UI" "Displays KPI dashboard, export buttons, trend charts/heatmaps, and filter options" "React Components"
                dataPreparation = component "Data Preparation" "Pre-aggregates metrics for dashboard, aggregates data from user queries, and formats data for exports" "Java Service"
                auditLogger = component "Audit Logger" "Logs user searches and report requests" "Java Service"
                cache = component "Cache" "Caches user searches and frequently accessed statistics" "Redis"
                databaseConnector = component "Database Connector" "Retrieves data from the database and enrollments system" "JDBC/REST Client"
            }

            studentInfoContainer = container "Student Information Service" "Manages student profiles and information access" "Spring Boot" {
                studentController = component "Student Controller" "Handles student information requests"
                studentProfileService = component "Student Profile Service" "Manages general student information"
                studentDetailsService = component "Student Details Service" "Manages specific student details for teachers"
            }

            notificationContainer = container "Notification Service" "Sends notifications to users about schedule changes" "Java / Python" {
                notificationController = component "Notification Controller" "Handles notification dispatch"
                emailProcessor = component "Email Processor" "Sends email notifications"
                calendarIntegration = component "Calendar Integration" "Syncs with external calendars"
                notificationQueue = component "Notification Queue" "Queues notifications for processing"
            }

            database = container "Database" "Stores timetables, rooms, preferences, user data, courses, enrollments" "PostgreSQL" {
                tags "Database"
            }

            auditLogService = container "Audit Log Service" "Records all system actions and changes for compliance" "Spring Boot" {
                tags "Infrastructure"
            }
        }

        # External Systems
        authProvider = softwareSystem "Auth / Identity Provider" "OAuth / LDAP authentication" {
            tags "External System"
        }

        externalCalendar = softwareSystem "External Calendar System" "Google Calendar / Outlook integration" {
            tags "External System"
        }

        emailProvider = softwareSystem "Email Provider" "SMTP or third-party email service" {
            tags "External System"
        }

        sisLdap = softwareSystem "University SIS / LDAP" "Source of users and user data" {
            tags "External System"
        }

        enrollmentSystem = softwareSystem "Enrollment System" "Manages student course registrations and enrollments" {
            tags "External System"
        }

        # Relationships - Users to System
        student -> universitySchedulingSystem "Uses"
        teacher -> universitySchedulingSystem "Uses"
        schedulingCommittee -> universitySchedulingSystem "Uses"
        managerAdmin -> universitySchedulingSystem "Uses"

        # Relationships - System to External Systems
        universitySchedulingSystem -> authProvider "Authenticates users"
        universitySchedulingSystem -> externalCalendar "Syncs events"
        universitySchedulingSystem -> emailProvider "Sends notifications"
        universitySchedulingSystem -> sisLdap "Loads user data"
        universitySchedulingSystem -> enrollmentSystem "Retrieves student enrollments and course registrations"

        # Container Relationships - Users to Containers
        student -> webapp "Views timetables and course info using" "HTTPS"
        teacher -> webapp "Manages preferences and views schedule using" "HTTPS"
        schedulingCommittee -> webapp "Creates and modifies timetables using" "HTTPS"
        managerAdmin -> webapp "Views reports using" "HTTPS"

        # Container Relationships - Web App to Feature Services
        webapp -> timetableViewingContainer "Requests timetable data" "REST/JSON"
        webapp -> courseInfoContainer "Requests course information" "REST/JSON"
        webapp -> teacherInfoContainer "Requests teacher information" "REST/JSON"
        webapp -> roomInfoContainer "Requests room information" "REST/JSON"
        webapp -> scheduleModificationContainer "Submits schedule changes" "REST/JSON"
        webapp -> timetableCreationContainer "Manages timetable creation" "REST/JSON"
        webapp -> conflictNotificationContainer "Checks for conflicts" "REST/JSON"
        webapp -> teacherPreferenceContainer "Manages preferences" "REST/JSON"
        webapp -> statisticsReportContainer "Requests reports" "REST/JSON"
        webapp -> studentInfoContainer "Requests student information" "REST/JSON"

        # Container Relationships - Feature Services to Database
        timetableViewingContainer -> database "Reads timetable data" "JDBC"
        courseInfoContainer -> database "Reads course data" "JDBC"
        teacherInfoContainer -> database "Reads teacher data" "JDBC"
        roomInfoContainer -> database "Reads/writes room data" "JDBC"
        scheduleModificationContainer -> database "Updates schedule data" "JDBC"
        timetableCreationContainer -> database "Writes timetable data" "JDBC"
        conflictNotificationContainer -> database "Reads enrollment and schedule data" "JDBC"
        teacherPreferenceContainer -> database "Reads/writes preference data" "JDBC"
        statisticsReportContainer -> database "Reads analytics data" "JDBC"
        studentInfoContainer -> database "Reads student data" "JDBC"

        # Container Relationships - Feature Services to External Systems
        timetableViewingContainer -> enrollmentSystem "Fetches enrolled courses" "REST"
        courseInfoContainer -> enrollmentSystem "Fetches enrollment status" "REST"
        courseInfoContainer -> authProvider "Validates permissions" "OAuth/LDAP"
        scheduleModificationContainer -> notificationContainer "Triggers notifications" "Message Queue"
        timetableCreationContainer -> notificationContainer "Triggers notifications" "Message Queue"

        notificationContainer -> emailProvider "Sends emails" "SMTP"
        notificationContainer -> externalCalendar "Syncs calendar events" "CalDAV/REST"

        teacherInfoContainer -> authProvider "Validates user roles" "OAuth/LDAP"
        scheduleModificationContainer -> authProvider "Validates permissions" "OAuth/LDAP"
        roomInfoContainer -> authProvider "Validates booking permissions" "OAuth/LDAP"

        studentInfoContainer -> sisLdap "Fetches student data" "LDAP"
        teacherInfoContainer -> sisLdap "Fetches teacher data" "LDAP"

        # Audit logging
        scheduleModificationContainer -> auditLogService "Logs modifications" "REST"
        timetableCreationContainer -> auditLogService "Logs timetable changes" "REST"
        teacherPreferenceContainer -> auditLogService "Logs preference changes" "REST"
        roomInfoContainer -> auditLogService "Logs room bookings" "REST"
        courseInfoContainer -> auditLogService "Logs course view events" "REST"

        # Component Relationships - Course Information Display Container (L3)

        # UI Component relationships
        courseDetailsView -> courseService "Requests core course details"
        instructorInfoView -> courseService "Requests instructor information"
        scheduleView -> courseService "Requests schedule and room data"
        prerequisitesView -> courseService "Requests prerequisite information and validation status"
        capacityView -> courseService "Requests enrollment and capacity data"
        descriptionView -> courseService "Requests course description and outcomes"
        creditsView -> courseService "Requests credit value and workload info"

        # Application Component relationships
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

        # Persistence Component relationships
        courseRepository -> database "Executes SQL queries for course metadata, prerequisites, credits"
        courseRepository -> accessLogger "Logs course data access"

        instructorRepository -> database "Executes SQL queries for instructor information"
        instructorRepository -> accessLogger "Logs instructor data access"

        scheduleRepository -> database "Executes SQL queries for schedule and room data"
        scheduleRepository -> accessLogger "Logs schedule data access"

        accessLogger -> auditLogService "Writes access logs and view events"

        # Component Relationships - Statistics Report Container (L3)
        statisticsUI -> dataPreparation "Requests aggregated data" "REST/JSON"
        statisticsUI -> cache "Checks for cached results" "Redis Protocol"

        dataPreparation -> databaseConnector "Requests raw data" "Method Call"
        dataPreparation -> cache "Stores aggregated results" "Redis Protocol"
        dataPreparation -> auditLogger "Logs data aggregation operations" "Method Call"

        cache -> auditLogger "Logs cache hits/misses" "Method Call"

        databaseConnector -> database "Queries statistics data" "SQL"
        databaseConnector -> enrollmentSystem "Fetches enrollment data" "REST API"
        databaseConnector -> auditLogger "Logs database queries" "Method Call"

        auditLogger -> auditLogService "Persists audit logs" "REST"


        cwTimetableDisplay -> courseDetailRequester "Course slot is clicked"
        wyTimetableDisplay -> courseDetailRequester "Course slot is clicked"
        courseDetailRequester -> courseInfoContainer "Redirects to"

        cwTimetableDisplay -> wyTimetableDisplay "Switches to"
        wyTimetableDisplay -> cwTimetableDisplay "Switches to"

        cwTimetableDisplay -> timetableInfoRequester "Gets data from"
        timetableInfoRequester -> cwTimetableDisplay "Gets data to"
        wyTimetableDisplay -> timetableInfoRequester "Gets data from"
        timetableInfoRequester -> wyTimetableDisplay "Gets data to"

        timetableInfoRequester -> timetableDatabase "Requests data from"
        timetableDatabase -> timetableInfoRequester "Data is loaded to"


        # Deployment Environment - Development
        deploymentEnvironment "Development" {
            deploymentNode "Developer Workstation" "Microsoft Windows 10, macOS, or Linux" {
                deploymentNode "Docker Desktop" "Docker Engine" {
                    webContainer = containerInstance webapp
                    timetableContainer = containerInstance timetableViewingContainer
                    courseContainer = containerInstance courseInfoContainer
                    teacherContainer = containerInstance teacherInfoContainer
                    roomContainer = containerInstance roomInfoContainer
                    modificationContainer = containerInstance scheduleModificationContainer
                    creationContainer = containerInstance timetableCreationContainer
                    conflictContainer = containerInstance conflictNotificationContainer
                    preferenceContainer = containerInstance teacherPreferenceContainer
                    statsContainer = containerInstance statisticsReportContainer
                    studentContainer = containerInstance studentInfoContainer
                    notifContainer = containerInstance notificationContainer
                    dbContainer = containerInstance database
                    auditContainer = containerInstance auditLogService
                }
            }

            deploymentNode "Local Services" {
                softwareSystemInstance authProvider
                softwareSystemInstance emailProvider
                softwareSystemInstance enrollmentSystem
            }
        }

        # Deployment Environment - Production
        deploymentEnvironment "Production" {
            deploymentNode "AWS Cloud" {
                region = deploymentNode "EU Central (Frankfurt)" {

                    availabilityZone1 = deploymentNode "Availability Zone 1" {
                        webServer1 = deploymentNode "EC2 - Web Server 1" "Amazon EC2 - t3.large" {
                            containerInstance webapp
                        }

                        featureServers1 = deploymentNode "EC2 - Feature Services Cluster 1" "Amazon EC2 - t3.xlarge" {
                            containerInstance timetableViewingContainer
                            containerInstance courseInfoContainer
                            containerInstance teacherInfoContainer
                            containerInstance roomInfoContainer
                        }

                        modificationServers1 = deploymentNode "EC2 - Modification Services 1" "Amazon EC2 - t3.xlarge" {
                            containerInstance scheduleModificationContainer
                            containerInstance timetableCreationContainer
                            containerInstance conflictNotificationContainer
                        }

                        preferenceServers1 = deploymentNode "EC2 - Preference & Stats Services 1" "Amazon EC2 - t3.large" {
                            containerInstance teacherPreferenceContainer
                            containerInstance statisticsReportContainer
                            containerInstance studentInfoContainer
                        }
                    }

                    availabilityZone2 = deploymentNode "Availability Zone 2" {
                        webServer2 = deploymentNode "EC2 - Web Server 2" "Amazon EC2 - t3.large" {
                            containerInstance webapp
                        }

                        featureServers2 = deploymentNode "EC2 - Feature Services Cluster 2" "Amazon EC2 - t3.xlarge" {
                            containerInstance timetableViewingContainer
                            containerInstance courseInfoContainer
                            containerInstance teacherInfoContainer
                            containerInstance roomInfoContainer
                        }

                        modificationServers2 = deploymentNode "EC2 - Modification Services 2" "Amazon EC2 - t3.xlarge" {
                            containerInstance scheduleModificationContainer
                            containerInstance timetableCreationContainer
                            containerInstance conflictNotificationContainer
                        }

                        preferenceServers2 = deploymentNode "EC2 - Preference & Stats Services 2" "Amazon EC2 - t3.large" {
                            containerInstance teacherPreferenceContainer
                            containerInstance statisticsReportContainer
                            containerInstance studentInfoContainer
                        }
                    }

                    loadBalancer = deploymentNode "Application Load Balancer" "AWS ALB" {
                        tags "Infrastructure"
                    }

                    databaseCluster = deploymentNode "RDS Database Cluster" {
                        primaryDb = deploymentNode "RDS Primary" "PostgreSQL 15 - db.r6g.xlarge" {
                            containerInstance database
                        }

                        replicaDb = deploymentNode "RDS Read Replica" "PostgreSQL 15 - db.r6g.large" {
                            containerInstance database
                        }
                    }

                    notificationNode = deploymentNode "EC2 - Notification Service" "Amazon EC2 - t3.medium" {
                        containerInstance notificationContainer
                    }

                    auditNode = deploymentNode "EC2 - Audit Service" "Amazon EC2 - t3.small" {
                        containerInstance auditLogService
                    }

                    queueService = deploymentNode "Amazon SQS" "Message Queue Service" {
                        tags "Infrastructure"
                    }
                }
            }

            deploymentNode "External Services" {
                softwareSystemInstance authProvider
                softwareSystemInstance externalCalendar
                softwareSystemInstance emailProvider
                softwareSystemInstance sisLdap
                softwareSystemInstance enrollmentSystem
            }
        }
    }

    views {
        systemContext universitySchedulingSystem "SystemContext" {
            include *
            autoLayout
        }

        container universitySchedulingSystem "Containers" {
            include *
            autoLayout
        }

        component timetableViewingContainer "TimetableViewingComponents" {
            include *
            autoLayout
        }

        component courseInfoContainer "CourseInfoComponents" {
            include *
            autoLayout
        }

        component teacherInfoContainer "TeacherInfoComponents" {
            include *
            autoLayout
        }

        component roomInfoContainer "RoomInfoComponents" {
            include *
            autoLayout
        }

        component scheduleModificationContainer "ScheduleModificationComponents" {
            include *
            autoLayout
        }

        component timetableCreationContainer "TimetableCreationComponents" {
            include *
            autoLayout
        }

        component conflictNotificationContainer "ConflictNotificationComponents" {
            include *
            autoLayout
        }

        component teacherPreferenceContainer "TeacherPreferenceComponents" {
            include *
            autoLayout
        }

        component statisticsReportContainer "StatisticsReportComponents" {
            include *
            autoLayout
        }

        component studentInfoContainer "StudentInfoComponents" {
            include *
            autoLayout
        }

        component notificationContainer "NotificationComponents" {
            include *
            autoLayout
        }

        # Dynamic views for Course Information Display
        dynamic courseInfoContainer "CourseInfoFlow_StudentViewsCourse" "Flow when a student views course details" {
            courseDetailsView -> courseService "1. Requests course details"
            courseService -> courseFinder "2. Validates course existence"
            courseFinder -> courseRepository "3. Queries course by ID"
            courseFinder -> cacheManager "4. Checks cache"
            courseService -> permissionService "5. Validates permissions"
            permissionService -> accessLogger "6. Logs permission checks"
            courseService -> courseAggregator "7. Requests assembled data"
            courseAggregator -> instructorDataService "8. Fetches instructor data"
            instructorDataService -> instructorRepository "9. Queries instructor"
            courseAggregator -> scheduleDataService "10. Fetches schedule data"
            scheduleDataService -> scheduleRepository "11. Queries schedule"
            courseAggregator -> prerequisiteChecker "12. Validates prerequisites"
            courseAggregator -> enrollmentDataService "13. Fetches enrollment data"
            autoLayout
        }

        dynamic courseInfoContainer "CourseInfoFlow_CachingStrategy" "How caching is managed in course info service" {
            courseFinder -> cacheManager "1. Checks cache for course lookup"
            instructorDataService -> cacheManager "2. Reads/writes cached instructor info"
            scheduleDataService -> cacheManager "3. Reads/writes cached schedule data"
            enrollmentDataService -> cacheManager "4. Reads/writes cached enrollment data"
            autoLayout
        }

        deployment universitySchedulingSystem "Development" "DevelopmentDeployment" {
            include *
            autoLayout
        }

        deployment universitySchedulingSystem "Production" "ProductionDeployment" {
            include *
            autoLayout
        }

        styles {
            element "Person" {
                shape Person
                background #08427b
                color #ffffff
            }

            element "Software System" {
                background #1168bd
                color #ffffff
            }

            element "External System" {
                background #999999
                color #ffffff
            }

            element "Container" {
                background #438dd5
                color #ffffff
            }

            element "Web Browser" {
                shape WebBrowser
            }

            element "Database" {
                shape Cylinder
            }

            element "Component" {
                background #85bbf0
                color #000000
            }

            element "Infrastructure" {
                shape RoundedBox
                background #f4a742
            }
        }

        theme default
    }

}