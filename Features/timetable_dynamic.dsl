workspace "Name" "Description" {

  !identifiers hierarchical

  model {
    student = person "Student"

    sis = softwareSystem "Student information system" {
      app = container "Web application"
      timetableViewer = container "Timetable viewer" {
        group "Presentation" {
          cwTimetableDisplay = component "Current week timetable display"
          wyTimetableDisplay = component "Whole year timetable display"
        }
        group "Business" {
          cwTimetableInfoRequester = component "Current week timetable info requester"
          wyTimetableInfoRequester = component "Whole year timetable info requester"
          modeSwitch = component "Switch timetable mode"
          enrolledCoursesInfoRequester = component "Enrolled courses info requester"
          courseDetailRequester = component "Course detail page requester"
        }
        group "Persistence" {
          timetableDatabase = component "Timetable database"
        }
      }
    }

    sis.timetableViewer.cwTimetableDisplay -> sis.timetableViewer.courseDetailRequester "Course slot is clicked"
    sis.timetableViewer.wyTimetableDisplay -> sis.timetableViewer.courseDetailRequester "Course slot is clicked"
    sis.timetableViewer.courseDetailRequester -> sis.courseDetailViewer "Redirects to"

    sis.timetableViewer.cwTimetableDisplay -> sis.timetableViewer.wyTimetableDisplay "Switches to"
    sis.timetableViewer.wyTimetableDisplay -> sis.timetableViewer.cwTimetableDisplay "Switches to"

    sis.timetableViewer.cwTimetableDisplay -> sis.timetableViewer.cwTimetableInfoRequester "Gets data from"
    sis.timetableViewer.cwTimetableInfoRequester -> sis.timetableViewer.cwTimetableDisplay "Gets data to"
    sis.timetableViewer.wyTimetableDisplay -> sis.timetableViewer.wyTimetableInfoRequester "Gets data from"
    sis.timetableViewer.wyTimetableInfoRequester -> sis.timetableViewer.wyTimetableDisplay "Gets data to"

    sis.timetableViewer.cwTimetableInfoRequester -> sis.timetableViewer.timetableDatabase "Requests data from"
    sis.timetableViewer.timetableDatabase -> sis.timetableViewer.cwTimetableInfoRequester "Data is loaded to"
    sis.timetableViewer.wyTimetableInfoRequester -> sis.timetableViewer.timetableDatabase "Requests data from"
    sis.timetableViewer.timetableDatabase -> sis.timetableViewer.wyTimetableInfoRequester "Data is loaded to"
  }

  views {
    styles {
      theme default
    }

    systemContext sis "L1" {
      autolayout tb
      include *
    }

    container sis "L2" {
      autolayout tb
      include *
    }

    component sis.timetableViewer "L3_TimetableViewer" {
      autolayout tb
      include *
    }

    dynamic sis.timetableViewer "Dynamic_TimetableViewer" {
      autolayout tb

      sis.app -> sis.timetableViewer.cwTimetableDisplay
      sis.timetableViewer.cwTimetableDisplay -> sis.timetableViewer.cwTimetableInfoRequester
      sis.timetableViewer.cwTimetableInfoRequester -> sis.timetableViewer.timetableDatabase
      sis.timetableViewer.timetableDatabase -> sis.timetableViewer.cwTimetableInfoRequester
      sis.timetableViewer.cwTimetableInfoRequester -> sis.timetableViewer.cwTimetableDisplay

      sis.timetableViewer.cwTimetableDisplay -> sis.timetableViewer.courseDetailRequester
      sis.timetableViewer.courseDetailRequester -> sis.courseDetailViewer
    }
  }
}
