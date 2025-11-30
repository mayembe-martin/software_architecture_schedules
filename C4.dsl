workspace "University Scheduling System" "A comprehensive university course scheduling and timetable management system" {

    !identifiers hierarchical

    model {
        # People
        student = person "Student" "Uses the platform to view timetables, course & teacher info"
        teacher = person "Teacher" "Views timetable, provides preferences, modifies schedule"
        schedulingCommittee = person "Scheduling Committee" "Creates timetables and resolves conflicts"
        managerAdmin = person "Manager / Admin" "Accesses overview and reports"
        academicAdvisor = person "Academic Advisor" "Assists students with course selection and planning"

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

        timetableService = softwareSystem "Timetable Service" "Manages course schedules and timeslots" {
            tags "External System"
        }

        courseManagementService = softwareSystem "Course Management Service" "Manages course catalog and metadata" {
            tags "External System"
        }

        prerequisiteService = softwareSystem "Prerequisite Validation Service" "Validates course prerequisites" {
            tags "External System"
        }

        # Main Software System
        universitySchedulingSystem = softwareSystem "University Scheduling System" "Manages timetables, rooms, preferences and notifications" {

            # Feature: Timetable Viewer (restored) - with Timetable View & Viewing Timetable View
            timetableViewer = container "Timetable Viewer" "Displays student timetables in current week and whole year views" "React / Spring Boot" {
                group "Presentation" {
                    cwTimetableDisplay = component "Current Week Timetable Display" "Displays current week timetable view"
                    wyTimetableDisplay = component "Whole Year Timetable Display" "Displays whole year timetable view"
                }

                group "Business" {
                    cwTimetableInfoRequester = component "Current Week Timetable Info Requester" "Retrieves current week timetable data"
                    wyTimetableInfoRequester = component "Whole Year Timetable Info Requester" "Retrieves whole year timetable data"
                    courseDetailRequester = component "Course Detail Page Requester" "Requests and redirects to course detail pages"
                }
                group "Persistence" {
                    timetableDatabase = component "Timetable Database Access" "Accesses timetable data from database"
                }
            }

            # Feature: Course Information Service (Yash)
            courseInfoContainer = container "Course Information Service" "Manages course details, teacher info, exam dates, and statistics (Yash)" "Spring Boot" {

                group "Application/Business Logic" {
                    courseService = component "Course Service" "Fetches core course details and coordinates all sub-services"
                    courseFinder = component "Course Finder / Catalog" "Searches for courses by ID and validates existence"
                    permissionService = component "Permission Service" "Validates student view permissions and enrollment status"
                    courseAggregator = component "Course Aggregator" "Merges instructor, schedule, capacity, prerequisites into unified response"
                    instructorDataService = component "Instructor Data Service" "Retrieves instructor information for assigned courses"
                    scheduleDataService = component "Schedule Data Service" "Retrieves timeslot and room information"
                    prerequisiteChecker = component "Prerequisite Checker" "Validates prerequisite fulfillment for students"
                    enrollmentDataService = component "Enrollment Data Service" "Retrieves capacity and current enrollment data"
                    examDateService = component "Exam Date Service" "Manages course examination dates"
                    courseStatisticsService = component "Course Statistics Service" "Computes and displays course statistics"
                }

                group "Persistence Layer" {
                    courseRepository = component "Course Repository" "Queries course metadata, description, credits, and prerequisites"
                    instructorRepository = component "Instructor Repository" "Queries instructor details and contact information"
                    scheduleRepository = component "Schedule Repository" "Queries weekly timeslots, room info, and calendar alignment"
                    courseCacheManager = component "Course Cache Manager" "Caches frequently accessed course metadata"
                    courseAccessLogger = component "Course Access Logger" "Logs course-info view events and permission violations"
                }
            }

            # Feature: Teacher/Room Information Service (Iker)
            teacherInfoContainer = container "Teacher Information Service" "Manages teacher profiles, office hours, and room information (Iker)" "Spring Boot" {

                group "Teacher Management" {
                    teacherController = component "Teacher Controller" "Handles teacher information requests"
                    teacherSearchService = component "Teacher Search Service" "Searches teachers by various criteria"
                    officeHoursService = component "Office Hours Service" "Manages and displays teacher office hours"
                    teacherProfileService = component "Teacher Profile Service" "Manages teacher profile information"
                    teacherValidationService = component "Validation Service" "Validates user roles and input data"
                }

                group "Office Hours Backend Components" {
                    officeHoursCtrl = component "OfficeHoursController" "REST Controller for handling /teachers/{id}/office-hours requests"
                    searchCtrl = component "Teacher Search Controller" "REST Controller for handling /teachers?filters"
                    authComp = component "Auth / Role Validator" "Security Component for validating tokens and enforcing role=student"
                    queryValidator = component "Search Input Validator" "Component for validating search filters and input"
                    teacherSvc = component "Teacher Service" "Business Logic for retrieving teacher profiles and orchestrating search"
                    officeSvc = component "Office Hours Service Component" "Business Logic for retrieving, computing and formatting office-hour slots"
                    scheduleSvc = component "Schedule Service" "Domain Logic for applying recurrence/exceptions and building slots"
                    teacherRepo = component "Teacher Repository Component" "Repository for reading teacher profiles from DB"
                    scheduleRepo = component "Schedule Repository Component" "Repository for reading schedule and exceptions from DB"
                    searchCache = component "Search Cache Adapter" "Infrastructure for caching teacher search results"
                    cacheAdapter = component "Cache Adapter" "Infrastructure for caching formatted office-hours slots"
                    notifEnq = component "Notification Enqueuer" "Infrastructure for enqueueing notifications for schedule changes"
                }


                group "Persistence" {
                    teacherRepository = component "Teacher Repository" "Abstracts database access for teacher entities"
                }

                group "Notification" {
                    emailProcessor = component "Email Processor" "Sends email notifications"
                    calendarIntegration = component "Calendar Integration" "Syncs with external calendars"
                    notificationQueue = component "Notification Queue" "Queues notifications for processing"
                }
            }

            # Feature: Schedule Modification Service (Vlad)
            scheduleModificationContainer = container "Schedule Modification Service" "Handles schedule changes and conflict detection (Vlad)" "Spring Boot" {

                group "Modification Management" {
                    modController = component "Modification Controller" "Receives modification requests"
                    workflowManager = component "Modification Workflow Manager" "Orchestrates validation, locking, and persistence"
                    conflictValidator = component "Conflict Validator" "Checks overlaps, room capacity, and constraints"
                    suggestionEngine = component "Suggestion Engine" "Finds alternative rooms or time slots"
                    scheduleEditorService = component "Schedule Editor Service" "Manages schedule editing operations"
                    authorizationService = component "Authorization Service" "Validates user permissions for modifications"
                }

                group "Concurrency & Impact" {
                    concurrencyManager = component "Concurrency Manager" "Handles record locking/versioning"
                    impactAnalyzer = component "Impact Analyzer" "Identifies users affected by a change"
                }

                group "Persistence" {
                    scheduleModRepository = component "Schedule Repository" "Persists timetable changes"
                }
            }

            # Feature: Statistical Reports Service (Martin)
            statisticsReportContainer = container "Statistical Reports Service" "Generates reports and analytics on resource utilization (Martin)" "Spring Boot" {
                statisticsUI = component "Statistics UI" "Displays KPI dashboard, export buttons, trend charts/heatmaps, and filter options" "React Components"
                dataPreparation = component "Data Preparation" "Pre-aggregates metrics for dashboard, aggregates data from user queries, and formats data for exports" "Java Service"
                auditLogger = component "Audit Logger" "Logs user searches and report requests" "Java Service"
                cache = component "Cache" "Caches user searches and frequently accessed statistics" "Redis"
                databaseConnector = component "Database Connector" "Retrieves data from the database and enrollments system" "JDBC/REST Client"
            }

            database = container "Main Database" "Stores timetables, rooms, preferences, user data, courses, enrollments" "PostgreSQL" {
                tags "Database"
            }

            redisCache = container "Redis Cache" "Stores frequently accessed data" "Redis" {
                tags "Database"
            }

            auditLogService = container "Audit Log Service" "Records all system actions and changes for compliance" "Spring Boot" {
                tags "Infrastructure"
            }
        }

        # User Relationships
        student -> universitySchedulingSystem "Uses"
        teacher -> universitySchedulingSystem "Uses"
        schedulingCommittee -> universitySchedulingSystem "Uses"
        managerAdmin -> universitySchedulingSystem "Uses"
        academicAdvisor -> universitySchedulingSystem "Uses"

        # System to External Systems
        universitySchedulingSystem -> authProvider "Authenticates users"
        universitySchedulingSystem -> externalCalendar "Syncs events"
        universitySchedulingSystem -> emailProvider "Sends notifications"
        universitySchedulingSystem -> sisLdap "Loads user data"
        universitySchedulingSystem -> enrollmentSystem "Retrieves student enrollments"
        universitySchedulingSystem -> timetableService "Pulls course schedules"
        universitySchedulingSystem -> courseManagementService "Pulls course catalog"
        universitySchedulingSystem -> prerequisiteService "Validates prerequisites"

        # Users to Timetable Viewer
        student -> universitySchedulingSystem.timetableViewer "Views timetables and searches teachers using" "HTTPS"
        teacher -> universitySchedulingSystem.timetableViewer "Manages schedule and views info using" "HTTPS"
        schedulingCommittee -> universitySchedulingSystem.timetableViewer "Modifies schedules using" "HTTPS"
        managerAdmin -> universitySchedulingSystem.timetableViewer "Views reports using" "HTTPS"
        academicAdvisor -> universitySchedulingSystem.timetableViewer "Assists students using" "HTTPS"

        # Timetable Viewer to Feature Services
        universitySchedulingSystem.timetableViewer -> universitySchedulingSystem.courseInfoContainer "Requests course information" "REST/JSON"
        universitySchedulingSystem.timetableViewer -> universitySchedulingSystem.teacherInfoContainer "Requests teacher and room information" "REST/JSON"
        universitySchedulingSystem.timetableViewer -> universitySchedulingSystem.scheduleModificationContainer "Submits schedule changes" "REST/JSON"
        universitySchedulingSystem.timetableViewer -> universitySchedulingSystem.statisticsReportContainer "Requests reports" "REST/JSON"

        # Timetable Viewer - Internal Component Relationships
        universitySchedulingSystem.timetableViewer.cwTimetableDisplay -> universitySchedulingSystem.timetableViewer.courseDetailRequester "Course slot is clicked"
        universitySchedulingSystem.timetableViewer.wyTimetableDisplay -> universitySchedulingSystem.timetableViewer.courseDetailRequester "Course slot is clicked"
        universitySchedulingSystem.timetableViewer.cwTimetableDisplay -> universitySchedulingSystem.timetableViewer.wyTimetableDisplay "Switches to"
        universitySchedulingSystem.timetableViewer.wyTimetableDisplay -> universitySchedulingSystem.timetableViewer.cwTimetableDisplay "Switches to"
        universitySchedulingSystem.timetableViewer.cwTimetableDisplay -> universitySchedulingSystem.timetableViewer.cwTimetableInfoRequester "Gets data from"
        universitySchedulingSystem.timetableViewer.cwTimetableInfoRequester -> universitySchedulingSystem.timetableViewer.cwTimetableDisplay "Returns data to"
        universitySchedulingSystem.timetableViewer.wyTimetableDisplay -> universitySchedulingSystem.timetableViewer.wyTimetableInfoRequester "Gets data from"
        universitySchedulingSystem.timetableViewer.wyTimetableInfoRequester -> universitySchedulingSystem.timetableViewer.wyTimetableDisplay "Returns data to"
        universitySchedulingSystem.timetableViewer.cwTimetableInfoRequester -> universitySchedulingSystem.timetableViewer.timetableDatabase "Requests data from"
        universitySchedulingSystem.timetableViewer.timetableDatabase -> universitySchedulingSystem.timetableViewer.cwTimetableInfoRequester "Loads data to"
        universitySchedulingSystem.timetableViewer.wyTimetableInfoRequester -> universitySchedulingSystem.timetableViewer.timetableDatabase "Requests data from"
        universitySchedulingSystem.timetableViewer.timetableDatabase -> universitySchedulingSystem.timetableViewer.wyTimetableInfoRequester "Loads data to"

        # Course detail navigation from timetable
        universitySchedulingSystem.timetableViewer.courseDetailRequester -> universitySchedulingSystem.courseInfoContainer.courseService "Redirects to course details"

        # Office Hours UI relationships in Timetable Viewer



        universitySchedulingSystem.courseInfoContainer.courseService -> universitySchedulingSystem.courseInfoContainer.courseFinder "Validates course existence"
        universitySchedulingSystem.courseInfoContainer.courseService -> universitySchedulingSystem.courseInfoContainer.permissionService "Validates user access"
        universitySchedulingSystem.courseInfoContainer.courseService -> universitySchedulingSystem.courseInfoContainer.courseAggregator "Requests fully assembled course data"

        universitySchedulingSystem.courseInfoContainer.courseFinder -> universitySchedulingSystem.courseInfoContainer.courseRepository "Queries course by ID"
        universitySchedulingSystem.courseInfoContainer.courseFinder -> universitySchedulingSystem.courseInfoContainer.courseCacheManager "Checks cache for course lookup"

        universitySchedulingSystem.courseInfoContainer.permissionService -> universitySchedulingSystem.courseInfoContainer.courseAccessLogger "Logs permission checks"

        universitySchedulingSystem.courseInfoContainer.courseAggregator -> universitySchedulingSystem.courseInfoContainer.instructorDataService "Fetches instructor data"
        universitySchedulingSystem.courseInfoContainer.courseAggregator -> universitySchedulingSystem.courseInfoContainer.scheduleDataService "Fetches schedule data"
        universitySchedulingSystem.courseInfoContainer.courseAggregator -> universitySchedulingSystem.courseInfoContainer.enrollmentDataService "Fetches capacity data"
        universitySchedulingSystem.courseInfoContainer.courseAggregator -> universitySchedulingSystem.courseInfoContainer.prerequisiteChecker "Fetches prerequisites"
        universitySchedulingSystem.courseInfoContainer.courseAggregator -> universitySchedulingSystem.courseInfoContainer.courseRepository "Fetches course metadata"

        universitySchedulingSystem.courseInfoContainer.instructorDataService -> universitySchedulingSystem.courseInfoContainer.instructorRepository "Queries instructor details"
        universitySchedulingSystem.courseInfoContainer.instructorDataService -> universitySchedulingSystem.courseInfoContainer.courseCacheManager "Reads/writes cached instructor info"

        universitySchedulingSystem.courseInfoContainer.scheduleDataService -> universitySchedulingSystem.courseInfoContainer.scheduleRepository "Queries timeslots and room info"
        universitySchedulingSystem.courseInfoContainer.scheduleDataService -> universitySchedulingSystem.courseInfoContainer.courseCacheManager "Reads/writes cached schedule data"

        universitySchedulingSystem.courseInfoContainer.prerequisiteChecker -> universitySchedulingSystem.courseInfoContainer.courseRepository "Queries prerequisite list"
        universitySchedulingSystem.courseInfoContainer.prerequisiteChecker -> universitySchedulingSystem.courseInfoContainer.permissionService "Validates prerequisite visibility"

        universitySchedulingSystem.courseInfoContainer.enrollmentDataService -> universitySchedulingSystem.courseInfoContainer.courseRepository "Queries capacity and enrollment"
        universitySchedulingSystem.courseInfoContainer.enrollmentDataService -> universitySchedulingSystem.courseInfoContainer.courseCacheManager "Reads/writes cached enrollment data"

        universitySchedulingSystem.courseInfoContainer.courseRepository -> universitySchedulingSystem.database "Executes SQL queries"
        universitySchedulingSystem.courseInfoContainer.instructorRepository -> universitySchedulingSystem.database "Executes SQL queries"
        universitySchedulingSystem.courseInfoContainer.scheduleRepository -> universitySchedulingSystem.database "Executes SQL queries"
        universitySchedulingSystem.courseInfoContainer.courseCacheManager -> universitySchedulingSystem.redisCache "Reads/writes cache"
        universitySchedulingSystem.courseInfoContainer.courseAccessLogger -> universitySchedulingSystem.auditLogService "Writes access logs"

        # Teacher/Room Info Service - Internal Component Relationships (including Office Hours)

        # Backend internal relationships for office hours
        universitySchedulingSystem.teacherInfoContainer.searchCtrl -> universitySchedulingSystem.teacherInfoContainer.authComp "Validate user role"
        universitySchedulingSystem.teacherInfoContainer.searchCtrl -> universitySchedulingSystem.teacherInfoContainer.queryValidator "Validate filters"
        universitySchedulingSystem.teacherInfoContainer.searchCtrl -> universitySchedulingSystem.teacherInfoContainer.searchCache "Check cache"
        universitySchedulingSystem.teacherInfoContainer.searchCtrl -> universitySchedulingSystem.teacherInfoContainer.teacherSvc "Delegate search logic"
        universitySchedulingSystem.teacherInfoContainer.searchCtrl -> universitySchedulingSystem.teacherInfoContainer.teacherRepo "Fetch teacher ids/list"

        universitySchedulingSystem.teacherInfoContainer.teacherSvc -> universitySchedulingSystem.teacherInfoContainer.teacherRepo "Read teacher profiles"
        universitySchedulingSystem.teacherInfoContainer.teacherSvc -> universitySchedulingSystem.teacherInfoContainer.searchCache "Update cache"

        universitySchedulingSystem.teacherInfoContainer.officeHoursCtrl -> universitySchedulingSystem.teacherInfoContainer.authComp "Validate user role"
        universitySchedulingSystem.teacherInfoContainer.officeHoursCtrl -> universitySchedulingSystem.teacherInfoContainer.officeSvc "Request office hours"

        universitySchedulingSystem.teacherInfoContainer.officeSvc -> universitySchedulingSystem.teacherInfoContainer.scheduleSvc "Compute/format slots"
        universitySchedulingSystem.teacherInfoContainer.scheduleSvc -> universitySchedulingSystem.teacherInfoContainer.cacheAdapter "Check cache"
        universitySchedulingSystem.teacherInfoContainer.scheduleSvc -> universitySchedulingSystem.teacherInfoContainer.scheduleRepo "Query schedule data"

        universitySchedulingSystem.teacherInfoContainer.scheduleRepo -> universitySchedulingSystem.database "SQL queries"
        universitySchedulingSystem.teacherInfoContainer.teacherRepo -> universitySchedulingSystem.database "SQL queries"

        universitySchedulingSystem.teacherInfoContainer.cacheAdapter -> universitySchedulingSystem.redisCache "GET/SET"
        universitySchedulingSystem.teacherInfoContainer.searchCache -> universitySchedulingSystem.redisCache "GET/SET"

        universitySchedulingSystem.teacherInfoContainer.scheduleSvc -> universitySchedulingSystem.teacherInfoContainer.notifEnq "Enqueue notification on change (if applicable)"
        universitySchedulingSystem.teacherInfoContainer.notifEnq -> universitySchedulingSystem.teacherInfoContainer.notificationQueue "Adds to queue"
        universitySchedulingSystem.teacherInfoContainer.notificationQueue -> universitySchedulingSystem.teacherInfoContainer.emailProcessor "Processes queued notifications"
        universitySchedulingSystem.teacherInfoContainer.emailProcessor -> emailProvider "Sends emails" "SMTP"
        universitySchedulingSystem.teacherInfoContainer.calendarIntegration -> externalCalendar "Syncs calendar events" "CalDAV/REST"


        universitySchedulingSystem.teacherInfoContainer.teacherController -> universitySchedulingSystem.teacherInfoContainer.teacherSearchService "Delegates search to"
        universitySchedulingSystem.teacherInfoContainer.teacherController -> universitySchedulingSystem.teacherInfoContainer.officeHoursService "Retrieves office hours from"
        universitySchedulingSystem.teacherInfoContainer.teacherController -> universitySchedulingSystem.teacherInfoContainer.teacherProfileService "Retrieves profile from"

        universitySchedulingSystem.teacherInfoContainer.teacherSearchService -> universitySchedulingSystem.teacherInfoContainer.teacherRepository "Queries teachers"
        universitySchedulingSystem.teacherInfoContainer.officeHoursService -> universitySchedulingSystem.teacherInfoContainer.teacherRepository "Queries office hours"
        universitySchedulingSystem.teacherInfoContainer.teacherProfileService -> universitySchedulingSystem.teacherInfoContainer.teacherRepository "Queries profile"

        universitySchedulingSystem.teacherInfoContainer.teacherRepository -> universitySchedulingSystem.database "Executes SQL SELECT"

        # Schedule Modification Service - Internal Component Relationships

        universitySchedulingSystem.scheduleModificationContainer.modController -> universitySchedulingSystem.scheduleModificationContainer.workflowManager "Initiates change transaction"

        universitySchedulingSystem.scheduleModificationContainer.workflowManager -> universitySchedulingSystem.scheduleModificationContainer.conflictValidator "Requests conflict check"
        universitySchedulingSystem.scheduleModificationContainer.workflowManager -> universitySchedulingSystem.scheduleModificationContainer.concurrencyManager "Acquires optimistic lock"
        universitySchedulingSystem.scheduleModificationContainer.workflowManager -> universitySchedulingSystem.scheduleModificationContainer.scheduleModRepository "Persists validated update"
        universitySchedulingSystem.scheduleModificationContainer.workflowManager -> universitySchedulingSystem.scheduleModificationContainer.impactAnalyzer "Requests list of affected students"

        universitySchedulingSystem.scheduleModificationContainer.conflictValidator -> universitySchedulingSystem.scheduleModificationContainer.scheduleModRepository "Reads occupied slots"
        universitySchedulingSystem.scheduleModificationContainer.suggestionEngine -> universitySchedulingSystem.scheduleModificationContainer.scheduleModRepository "Scans for empty time slots"

        universitySchedulingSystem.scheduleModificationContainer.authorizationService -> authProvider "Validates permissions"

        universitySchedulingSystem.scheduleModificationContainer.scheduleModRepository -> universitySchedulingSystem.database "Executes SQL INSERT/UPDATE"
        universitySchedulingSystem.scheduleModificationContainer.impactAnalyzer -> universitySchedulingSystem.teacherInfoContainer.notificationQueue "Triggers notifications"

        # Statistics Report Service - Internal Component Relationships
        universitySchedulingSystem.statisticsReportContainer.statisticsUI -> universitySchedulingSystem.statisticsReportContainer.dataPreparation "Requests aggregated data" "REST/JSON"
        universitySchedulingSystem.statisticsReportContainer.statisticsUI -> universitySchedulingSystem.statisticsReportContainer.cache "Checks for cached results" "Redis Protocol"

        universitySchedulingSystem.statisticsReportContainer.dataPreparation -> universitySchedulingSystem.statisticsReportContainer.databaseConnector "Requests raw data"
        universitySchedulingSystem.statisticsReportContainer.dataPreparation -> universitySchedulingSystem.statisticsReportContainer.cache "Stores aggregated results"
        universitySchedulingSystem.statisticsReportContainer.dataPreparation -> universitySchedulingSystem.statisticsReportContainer.auditLogger "Logs data aggregation operations"

        universitySchedulingSystem.statisticsReportContainer.cache -> universitySchedulingSystem.statisticsReportContainer.auditLogger "Logs cache hits/misses"

        universitySchedulingSystem.statisticsReportContainer.databaseConnector -> universitySchedulingSystem.database "Queries statistics data"
        universitySchedulingSystem.statisticsReportContainer.databaseConnector -> enrollmentSystem "Fetches enrollment data"
        universitySchedulingSystem.statisticsReportContainer.databaseConnector -> universitySchedulingSystem.statisticsReportContainer.auditLogger "Logs database queries"

        universitySchedulingSystem.statisticsReportContainer.auditLogger -> universitySchedulingSystem.auditLogService "Persists audit logs"

        # Feature Services to Database & External Systems
        universitySchedulingSystem.courseInfoContainer -> universitySchedulingSystem.database "Reads course data" "JDBC"
        universitySchedulingSystem.courseInfoContainer -> universitySchedulingSystem.redisCache "Caches course data" "Redis"
        universitySchedulingSystem.courseInfoContainer -> timetableService "Pulls schedules" "REST"
        universitySchedulingSystem.courseInfoContainer -> courseManagementService "Pulls catalog" "REST"
        universitySchedulingSystem.courseInfoContainer -> prerequisiteService "Validates prerequisites" "REST"
        universitySchedulingSystem.courseInfoContainer -> enrollmentSystem "Fetches enrollments" "REST"

        universitySchedulingSystem.teacherInfoContainer -> universitySchedulingSystem.database "Reads teacher/room data" "JDBC"
        universitySchedulingSystem.teacherInfoContainer -> universitySchedulingSystem.redisCache "Caches data" "Redis"
        universitySchedulingSystem.teacherInfoContainer -> sisLdap "Fetches teacher data" "LDAP"
        universitySchedulingSystem.teacherInfoContainer -> authProvider "Validates roles" "OAuth/LDAP"

        universitySchedulingSystem.scheduleModificationContainer -> universitySchedulingSystem.database "Updates schedule data" "JDBC"

        universitySchedulingSystem.statisticsReportContainer -> universitySchedulingSystem.database "Reads analytics data" "JDBC"
        universitySchedulingSystem.statisticsReportContainer -> universitySchedulingSystem.redisCache "Caches statistics" "Redis"


        # Audit Logging
        universitySchedulingSystem.scheduleModificationContainer -> universitySchedulingSystem.auditLogService "Logs modifications" "REST"
        universitySchedulingSystem.courseInfoContainer -> universitySchedulingSystem.auditLogService "Logs access" "REST"

        # Deployment Environment - Development
        deploymentEnvironment "Development" {
            deploymentNode "Developer Workstation" "Microsoft Windows 10, macOS, or Linux" {
                deploymentNode "Docker Desktop" "Docker Engine" {
                    containerInstance universitySchedulingSystem.courseInfoContainer
                    containerInstance universitySchedulingSystem.teacherInfoContainer
                    containerInstance universitySchedulingSystem.scheduleModificationContainer
                    containerInstance universitySchedulingSystem.statisticsReportContainer
                    containerInstance universitySchedulingSystem.database
                    containerInstance universitySchedulingSystem.redisCache
                    containerInstance universitySchedulingSystem.auditLogService
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
                        timetableServer1 = deploymentNode "EC2 - Timetable Viewer 1" "Amazon EC2 - t3.large" {
                            containerInstance universitySchedulingSystem.timetableViewer
                        }

                        featureServers1 = deploymentNode "EC2 - Course & Teacher Services 1" "Amazon EC2 - t3.xlarge" {
                            containerInstance universitySchedulingSystem.courseInfoContainer
                            containerInstance universitySchedulingSystem.teacherInfoContainer
                        }

                        modificationServers1 = deploymentNode "EC2 - Modification Services 1" "Amazon EC2 - t3.xlarge" {
                            containerInstance universitySchedulingSystem.scheduleModificationContainer
                        }

                        statsServers1 = deploymentNode "EC2 - Stats Services 1" "Amazon EC2 - t3.large" {
                            containerInstance universitySchedulingSystem.statisticsReportContainer
                        }
                    }

                    availabilityZone2 = deploymentNode "Availability Zone 2" {
                        timetableServer2 = deploymentNode "EC2 - Timetable Viewer 2" "Amazon EC2 - t3.large" {
                            containerInstance universitySchedulingSystem.timetableViewer
                        }

                        featureServers2 = deploymentNode "EC2 - Course & Teacher Services 2" "Amazon EC2 - t3.xlarge" {
                            containerInstance universitySchedulingSystem.courseInfoContainer
                            containerInstance universitySchedulingSystem.teacherInfoContainer
                        }

                        modificationServers2 = deploymentNode "EC2 - Modification Services 2" "Amazon EC2 - t3.xlarge" {
                            containerInstance universitySchedulingSystem.scheduleModificationContainer
                        }

                        statsServers2 = deploymentNode "EC2 - Stats Services 2" "Amazon EC2 - t3.large" {
                            containerInstance universitySchedulingSystem.statisticsReportContainer
                        }
                    }

                    loadBalancer = deploymentNode "Application Load Balancer" "AWS ALB" {
                        tags "Infrastructure"
                    }

                    databaseCluster = deploymentNode "RDS Database Cluster" {
                        primaryDb = deploymentNode "RDS Primary" "PostgreSQL 15 - db.r6g.xlarge" {
                            containerInstance universitySchedulingSystem.database
                        }

                        replicaDb = deploymentNode "RDS Read Replica" "PostgreSQL 15 - db.r6g.large" {
                            containerInstance universitySchedulingSystem.database
                        }
                    }

                    cacheCluster = deploymentNode "ElastiCache Redis Cluster" {
                        containerInstance universitySchedulingSystem.redisCache
                    }

                    auditNode = deploymentNode "EC2 - Audit Service" "Amazon EC2 - t3.small" {
                        containerInstance universitySchedulingSystem.auditLogService
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
                softwareSystemInstance timetableService
                softwareSystemInstance courseManagementService
                softwareSystemInstance prerequisiteService
            }
        }
    }

    views {
        systemContext universitySchedulingSystem "SystemContext" {
            include *
            autolayout lr
        }

        container universitySchedulingSystem "Containers" {
            include *
            autolayout tb
        }


        component universitySchedulingSystem.courseInfoContainer "CourseInfoComponents" {
            include *
            autolayout tb
        }

        component universitySchedulingSystem.timetableViewer "TimetableView" {
            include *
            autolayout tb
        }

        component universitySchedulingSystem.teacherInfoContainer "TeacherRoomInfoComponents" {
            include *
            autolayout tb
        }

        component universitySchedulingSystem.scheduleModificationContainer "ScheduleModificationComponents" {
            include *
            autolayout tb
        }

        component universitySchedulingSystem.statisticsReportContainer "StatisticsReportComponents" {
            include *
            autolayout tb
        }

        dynamic universitySchedulingSystem.timetableViewer "Dynamic_TimetableViewer" {
          autolayout tb

          universitySchedulingSystem.timetableViewer.cwTimetableDisplay -> universitySchedulingSystem.timetableViewer.cwTimetableInfoRequester
          universitySchedulingSystem.timetableViewer.cwTimetableInfoRequester -> universitySchedulingSystem.timetableViewer.timetableDatabase
          universitySchedulingSystem.timetableViewer.timetableDatabase -> universitySchedulingSystem.timetableViewer.cwTimetableInfoRequester
          universitySchedulingSystem.timetableViewer.cwTimetableInfoRequester -> universitySchedulingSystem.timetableViewer.cwTimetableDisplay

          universitySchedulingSystem.timetableViewer.cwTimetableDisplay -> universitySchedulingSystem.timetableViewer.courseDetailRequester
          universitySchedulingSystem.timetableViewer.courseDetailRequester -> universitySchedulingSystem.courseInfoContainer
        }
        
        
        dynamic universitySchedulingSystem.courseInfoContainer "Dynamic_CourseInfoFlow" "Flow when a student views course details" {
            autolayout lr

            universitySchedulingSystem.courseInfoContainer.courseService -> universitySchedulingSystem.courseInfoContainer.courseFinder "1. Validates course existence"
            universitySchedulingSystem.courseInfoContainer.courseFinder -> universitySchedulingSystem.courseInfoContainer.courseRepository "2. Queries course by ID"
            universitySchedulingSystem.courseInfoContainer.courseFinder -> universitySchedulingSystem.courseInfoContainer.courseCacheManager "3. Checks cache"
            universitySchedulingSystem.courseInfoContainer.courseService -> universitySchedulingSystem.courseInfoContainer.permissionService "4. Validates permissions"
            universitySchedulingSystem.courseInfoContainer.permissionService -> universitySchedulingSystem.courseInfoContainer.courseAccessLogger "5. Logs permission checks"
            universitySchedulingSystem.courseInfoContainer.courseService -> universitySchedulingSystem.courseInfoContainer.courseAggregator "6. Requests assembled data"
            universitySchedulingSystem.courseInfoContainer.courseAggregator -> universitySchedulingSystem.courseInfoContainer.instructorDataService "7. Fetches instructor data"
            universitySchedulingSystem.courseInfoContainer.instructorDataService -> universitySchedulingSystem.courseInfoContainer.instructorRepository "8. Queries instructor"
            universitySchedulingSystem.courseInfoContainer.courseAggregator -> universitySchedulingSystem.courseInfoContainer.scheduleDataService "9. Fetches schedule data"
            universitySchedulingSystem.courseInfoContainer.scheduleDataService -> universitySchedulingSystem.courseInfoContainer.scheduleRepository "10. Queries schedule"
            universitySchedulingSystem.courseInfoContainer.courseAggregator -> universitySchedulingSystem.courseInfoContainer.prerequisiteChecker "11. Validates prerequisites"
            universitySchedulingSystem.courseInfoContainer.courseAggregator -> universitySchedulingSystem.courseInfoContainer.enrollmentDataService "12. Fetches enrollment data"
        }


        deployment universitySchedulingSystem "Development" "DevelopmentDeployment" {
            include *
            autolayout lr
        }

        deployment universitySchedulingSystem "Production" "ProductionDeployment" {
            include *
            autolayout tb
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
                background #2f71ab
                color #ffffff
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