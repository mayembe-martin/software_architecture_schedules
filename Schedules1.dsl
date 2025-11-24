workspace "University Scheduling System" "A comprehensive university course scheduling and timetable management system" {

    model {
        # People
        student = person "Student" "Uses the platform to view timetables, course & teacher info"
        teacher = person "Teacher" "Views timetable, provides preferences, modifies schedule"
        schedulingCommittee = person "Scheduling Committee" "Creates timetables and resolves conflicts"
        managerAdmin = person "Manager / Admin" "Accesses overview and reports"
        
        # Software Systems
        universitySchedulingSystem = softwareSystem "University Scheduling System" "Manages timetables, rooms, preferences and notifications" {
            webapp = container "Web Application" "Delivers scheduling functionality to users" "React / Angular" {
                studentUI = component "Student Interface" "Allows students to view timetables and course information"
                teacherUI = component "Teacher Interface" "Allows teachers to manage preferences and view schedules"
                schedulingUI = component "Scheduling Interface" "Allows committee to create and manage timetables"
                adminUI = component "Admin Interface" "Provides reports and system overview"
            }
            
            api = container "API Application" "Provides scheduling functionality via REST API" "Spring Boot / Node.js" {
                authController = component "Authentication Controller" "Handles user authentication"
                timetableController = component "Timetable Controller" "Manages timetable operations"
                roomController = component "Room Controller" "Manages room allocation"
                notificationController = component "Notification Controller" "Handles notification dispatch"
            }
            
            database = container "Database" "Stores timetables, rooms, preferences, user data" "PostgreSQL / MySQL" {
                tags "Database"
            }
            
            notificationService = container "Notification Service" "Processes and sends notifications" "Java / Python" {
                emailProcessor = component "Email Processor" "Sends email notifications"
                integrationHandler = component "Calendar Integration Handler" "Syncs with external calendars"
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
        
        sisLdap = softwareSystem "University SIS / LDAP" "Source of users and enrollment data" {
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
        universitySchedulingSystem -> sisLdap "Loads users and enrollments"
        universitySchedulingSystem -> enrollmentSystem "Retrieves student enrollments and course registrations"
        
        # Container Relationships
        student -> webapp "Views timetables using" "HTTPS"
        teacher -> webapp "Manages preferences using" "HTTPS"
        schedulingCommittee -> webapp "Creates timetables using" "HTTPS"
        managerAdmin -> webapp "Views reports using" "HTTPS"
        
        webapp -> api "Makes API calls to" "JSON/HTTPS"
        api -> database "Reads from and writes to" "JDBC/SQL"
        api -> notificationService "Triggers notifications" "Message Queue"
        
        api -> authProvider "Authenticates via" "OAuth/LDAP"
        api -> sisLdap "Fetches data from" "LDAP/REST"
        api -> enrollmentSystem "Queries enrollments from" "REST API"
        
        notificationService -> emailProvider "Sends emails via" "SMTP"
        notificationService -> externalCalendar "Syncs calendar events" "CalDAV/REST"
        
        # Deployment Environment - Development
        deploymentEnvironment "Development" {
            deploymentNode "Developer Workstation" "Microsoft Windows 10, macOS, or Linux" {
                deploymentNode "Docker Desktop" "Docker Engine" {
                    containerInstance webapp
                    containerInstance api
                    containerInstance database
                    containerInstance notificationService
                }
            }
            
            deploymentNode "Local Services" {
                softwareSystemInstance authProvider
                softwareSystemInstance emailProvider
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
                        
                        appServer1 = deploymentNode "EC2 - Application Server 1" "Amazon EC2 - t3.xlarge" {
                            containerInstance api
                        }
                    }
                    
                    availabilityZone2 = deploymentNode "Availability Zone 2" {
                        webServer2 = deploymentNode "EC2 - Web Server 2" "Amazon EC2 - t3.large" {
                            containerInstance webapp
                        }
                        
                        appServer2 = deploymentNode "EC2 - Application Server 2" "Amazon EC2 - t3.xlarge" {
                            containerInstance api
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
                        containerInstance notificationService
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
        
        component webapp "WebAppComponents" {
            include *
            autoLayout
        }
        
        component api "APIComponents" {
            include *
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
