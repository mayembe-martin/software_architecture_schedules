workspace "Statistical Reports - Multi-Level Views" "Container and Component views for the Statistical Reports subsystem" {
  model {
    # External users
    student = person "Student" "Views reports and analytics"
    teacher = person "Teacher" "Views course and room analytics"
    committeMember = person "Committee Member" "Views system-wide analytics and KPIs"
    staffMember = person "Staff Member" "Views utilization reports and system metrics"
    
    # External systems/containers
    timetableService = softwareSystem "Timetable Service" "Manages student and teacher timetables"
    courseInfoService = softwareSystem "Course Information Service" "Provides course details and enrollment data"
    teacherInfoService = softwareSystem "Teacher Information Service" "Manages teacher profiles and availability"
    roomInfoService = softwareSystem "Room Information Service" "Manages room details and bookings"
    scheduleModificationService = softwareSystem "Schedule Modification Service" "Handles schedule changes"
    timetableCreationService = softwareSystem "Timetable Creation Service" "Generates timetables"
    conflictDetectionService = softwareSystem "Conflict Detection Service" "Identifies schedule conflicts"
    notificationService = softwareSystem "Notification Service" "Sends notifications"
    
    # The Statistical Reports System (your feature)
    reportingSystem = softwareSystem "Statistical Reports" "Provides utilization analytics, KPI dashboards and exports" {
      
      # Level 2: Containers
      ui = container "Presentation/UI" "Displays dashboards, heatmaps, KPI tiles, quick filters and export buttons" "Web UI (React/Angular)" {
        # Level 3: UI Components
        kpiDashboard = component "KPI Dashboard" "Displays at-a-glance metrics with traffic-light status (green/amber/red)" "React Component"
        heatmapViewer = component "Heatmap Viewer" "Renders room/slot heatmaps and trend charts" "React Component + D3.js"
        filterPanel = component "Filter Panel" "Provides quick filters (term, program, department, campus, teacher, room)" "React Component"
        exportControls = component "Export Controls" "Handles export button actions and scheduled export configuration" "React Component"
        drillDownView = component "Drill-Down View" "Navigates from KPI to offending assignments with suggested fixes" "React Component"
      }
      
      application = container "Application/Business Logic" "Pre-aggregates metrics, executes drill-downs, prepares export files and serves KPIs" "Backend Service (Java/Python/Node)" {
        # Level 3: Application Components
        metricsAggregator = component "Metrics Aggregator" "Pre-aggregates resource utilization metrics (room, equipment, teacher time)" "Service Class"
        utilizationCalculator = component "Utilization Calculator" "Calculates room utilization by hour/day/building/term and equipment saturation" "Service Class"
        teacherWorkloadAnalyzer = component "Teacher Workload Analyzer" "Analyzes teacher time utilization patterns" "Service Class"
        drillDownEngine = component "Drill-Down Engine" "Executes drill-down queries from KPI to assignments and generates fix suggestions" "Service Class"
        exportFormatter = component "Export Formatter" "Aggregates and formats data for CSV/XLSX exports" "Service Class"
        exportScheduler = component "Export Scheduler" "Manages scheduled exports and snapshot comparisons" "Service Class + Cron"
        queryOptimizer = component "Query Optimizer" "Optimizes aggregation queries for presentation layer" "Service Class"
      }
      
      persistence = container "Persistence Layer" "Data retrieval, cache, and audit logging" "DB + Cache + Logging" {
        # Level 3: Persistence Components
        dataRetriever = component "Data Retriever" "Retrieves scheduling data from database based on filter queries" "Repository"
        cacheManager = component "Cache Manager" "Caches user queries and pre-aggregated results" "Cache Service"
        accessLogger = component "Access Logger" "Logs user access patterns and view requests" "Logging Service"
        exportLogger = component "Export Logger" "Logs export actions and scheduled export executions" "Logging Service"
      }
      
      db = container "Database" "Stores raw scheduling data and aggregated metrics" "PostgreSQL/MySQL"
      cache = container "Cache" "Caches user queries and pre-aggregated results for faster responses" "Redis"
      audit = container "Audit Logger" "Stores user interactions, searches, view accesses and export logs" "Logging Service (ELK/Cloud)"
    }
    
    # Level 2: Internal relationships within Statistical Reports
    ui -> application "Sends filter selections, KPI and drill-down requests, triggers exports"
    application -> persistence "Requests data retrieval, reads/writes cached aggregates, logs events"
    persistence -> db "Reads and writes scheduling and aggregate data"
    persistence -> cache "Reads from and writes to cache"
    persistence -> audit "Writes audit events (searches, views, exports)"
    
    # Level 3: UI Component relationships
    kpiDashboard -> metricsAggregator "Requests pre-aggregated KPI metrics"
    heatmapViewer -> utilizationCalculator "Requests room/slot utilization data"
    heatmapViewer -> teacherWorkloadAnalyzer "Requests teacher time data"
    filterPanel -> queryOptimizer "Sends filter criteria for optimization"
    exportControls -> exportFormatter "Triggers export generation"
    exportControls -> exportScheduler "Configures scheduled exports"
    drillDownView -> drillDownEngine "Requests drill-down analysis"
    
    # Level 3: Application Component relationships
    metricsAggregator -> utilizationCalculator "Delegates resource utilization calculations"
    metricsAggregator -> teacherWorkloadAnalyzer "Delegates teacher workload analysis"
    metricsAggregator -> dataRetriever "Fetches raw scheduling data"
    
    utilizationCalculator -> dataRetriever "Queries room and equipment booking data"
    utilizationCalculator -> cacheManager "Reads/writes cached utilization metrics"
    
    teacherWorkloadAnalyzer -> dataRetriever "Queries teacher assignment data"
    teacherWorkloadAnalyzer -> cacheManager "Reads/writes cached workload analysis"
    
    drillDownEngine -> dataRetriever "Queries assignment details"
    drillDownEngine -> metricsAggregator "Uses aggregated metrics for analysis"
    
    exportFormatter -> metricsAggregator "Gets aggregated data for export"
    exportFormatter -> queryOptimizer "Optimizes data queries for large exports"
    exportFormatter -> exportLogger "Logs export operations"
    
    exportScheduler -> exportFormatter "Triggers scheduled export jobs"
    exportScheduler -> exportLogger "Logs scheduled execution"
    
    queryOptimizer -> cacheManager "Checks cache before querying database"
    queryOptimizer -> dataRetriever "Executes optimized queries"
    
    # Level 3: Persistence Component relationships
    dataRetriever -> db "Executes SQL queries for scheduling data"
    dataRetriever -> accessLogger "Logs data access requests"
    
    cacheManager -> cache "Reads and writes cached query results"
    
    accessLogger -> audit "Writes access logs"
    exportLogger -> audit "Writes export logs"
    
    # User interactions
    student -> ui "Views personal schedule analytics and course statistics"
    teacher -> ui "Views course performance and room utilization metrics"
    committeMember -> ui "Views system-wide KPIs and timetable optimization metrics"
    staffMember -> ui "Views utilization reports, room analytics, and system usage"
    
    # External system interactions (data exchange)
    application -> timetableService "Pulls timetable data for analytics and aggregation"
    application -> courseInfoService "Pulls course enrollment and statistics data"
    application -> teacherInfoService "Pulls teacher workload and availability data"
    application -> roomInfoService "Pulls room utilization and booking data"
    application -> scheduleModificationService "Pulls change history for modification analytics"
    application -> timetableCreationService "Pulls timetable generation metrics and efficiency data"
    application -> conflictDetectionService "Pulls conflict occurrence data for quality metrics"
    application -> notificationService "Pulls notification delivery statistics"
  }
  
  views {
    systemContext reportingSystem "SystemContext" "System context showing Statistical Reports and external interactions" {
      include *
      autolayout lr
    }
    
    container reportingSystem "ContainerView" "Level 2: Container-level view for Statistical Reports" {
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