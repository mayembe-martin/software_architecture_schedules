workspace {

  model {
    user = person "Student" "Uses the system to view teacher office hours"

    teacherSystem = softwareSystem "University Scheduling System" "Manages timetables and teacher info" {
      url "file:///mnt/data/d89644e9-d04b-4772-9901-b73c9ce43d6d.png"

      web = container "Web Frontend - Student Portal" "React SPA" "Student UI" {
        loginView = component "Login View" "UI Component" "Handles authentication UI"
        dashboardView = component "Student Dashboard" "UI Component" "Main navigation"
        teacherSearchView = component "Teacher Search View" "UI Component" "Search filters and results"
        teacherProfileView = component "Teacher Profile View" "UI Component" "Teacher info"
        officeHoursView = component "Office Hours View" "UI Component" "Shows office hours"
        apiClient = component "API Client" "JS Module" "HTTP client for backend"
      }

      api = container "Backend API" "REST API" "Business logic" {
        searchCtrl = component "Teacher Search Controller" "Controller" "Handle teacher search requests"
        officeHoursCtrl = component "OfficeHoursController" "Controller" "Handle office hours requests"
        authComp = component "Auth / Role Validator" "Security" "Validate tokens and roles"
        queryValidator = component "Search Input Validator" "Component" "Validate search filters"
        teacherSvc = component "Teacher Service" "Service" "Retrieve teacher profiles"
        officeSvc = component "Office Hours Service" "Service" "Compute and format office hours"
        scheduleSvc = component "Schedule Service" "Service" "Apply recurrence and exceptions"
        teacherRepo = component "Teacher Repository" "Repository" "Reads teacher data"
        scheduleRepo = component "Schedule Repository" "Repository" "Reads schedule data"
        searchCache = component "Search Cache Adapter" "Infrastructure" "Cache search results"
        cacheAdapter = component "Cache Adapter" "Infrastructure" "Cache formatted slots"
        notifEnq = component "Notification Enqueuer" "Infrastructure" "Enqueue notifications"
      }

      db = container "Relational Database" "PostgreSQL" "Stores teachers and schedules"
      redis = container "Redis Cache" "Redis" "Cache for searches and slots"
    }

    user -> web "Uses the student UI"
    web -> api "Sends HTTP requests to backend"
    api -> web "Responds with data"

    apiClient -> searchCtrl "Calls teacher search endpoint"
    searchCtrl -> apiClient "Returns teachers list (HTTP response)"

    apiClient -> officeHoursCtrl "Requests office hours for selected teacher"
    officeHoursCtrl -> apiClient "Returns office hours (HTTP response)"

    searchCtrl -> authComp "Validate user token and role"
    searchCtrl -> queryValidator "Validate search filters"
    searchCtrl -> teacherSvc "Delegate search logic"
    teacherSvc -> teacherRepo "Query teachers in repository"
    teacherRepo -> db "Read teacher rows from database"
    teacherRepo -> teacherSvc "Return teacher list"
    teacherSvc -> searchCtrl "Return search results"

    officeHoursCtrl -> authComp "Validate token and role"
    officeHoursCtrl -> officeSvc "Request office hours from service"
    officeSvc -> scheduleSvc "Resolve recurrences and build slots"
    scheduleSvc -> cacheAdapter "Check cache for formatted slots"
    cacheAdapter -> redis "Redis GET for formatted slots"
    scheduleSvc -> scheduleRepo "Query schedule rows if cache miss"
    scheduleRepo -> db "Read schedule rows from database"
    scheduleRepo -> scheduleSvc "Return schedule data"
    scheduleSvc -> officeSvc "Return formatted slots"
    officeSvc -> officeHoursCtrl "Return DTO with slots"

    cacheAdapter -> redis "Read/Write cache"
    teacherRepo -> db "Reads teacher rows"
    scheduleRepo -> db "Reads schedule rows"
  }

  views {
    
    dynamic teacherSystem {
      title "Sequence: Viewing teacher office hours (dynamic diagram) - Container level"

      user -> web "Student opens dashboard and clicks Teachers"
      web -> api "Request teacher search with filters"
      web -> api "GET office hours for selected teacher"
      api -> web "Deliver teachers list / office hours to frontend"
      web -> user "Render office hours to student"

      description "High-level dynamic diagram between actor and containers."
    }

        dynamic api {
      title "Sequence: Viewing teacher office hours (dynamic diagram) - Backend component level"

      apiClient -> searchCtrl "API client calls search endpoint"
      searchCtrl -> authComp "Validate user token and role"
      searchCtrl -> queryValidator "Validate search filters"
      searchCtrl -> teacherSvc "Delegate search logic"
      teacherSvc -> teacherRepo "Query teachers in repository"
      teacherRepo -> db "Read teacher rows from database"
      teacherRepo -> teacherSvc "Return teacher list"
      teacherSvc -> searchCtrl "Return search results"
      searchCtrl -> apiClient "Return HTTP response with teachers list"

      apiClient -> officeHoursCtrl "API client fetches office hours"
      officeHoursCtrl -> authComp "Validate token and role"
      officeHoursCtrl -> officeSvc "Request office hours from service"
      officeSvc -> scheduleSvc "Resolve recurrences and build slots"
      scheduleSvc -> cacheAdapter "Check cache for formatted slots"
      cacheAdapter -> redis "Redis GET for formatted slots"
      scheduleSvc -> scheduleRepo "Query schedule rows if cache miss"
      scheduleRepo -> db "Read schedule rows from database"
      scheduleRepo -> scheduleSvc "Return schedule data"
      scheduleSvc -> officeSvc "Return formatted slots"
      officeSvc -> officeHoursCtrl "Return DTO with slots"
      officeHoursCtrl -> apiClient "Return HTTP 200 with office hours"

      description "Detailed backend flow between API client and internal backend components."
    }

    container teacherSystem {
      include *
      autolayout lr
      title "L2 - Container Diagram"
    }

    component api {
      include *
      autolayout lr
      title "L3 - Backend Components (Office Hours)"
    }

    component web {
      include *
      autolayout lr
      title "L3 - Web Components (Office Hours)"
    }

    theme default
  }
}
