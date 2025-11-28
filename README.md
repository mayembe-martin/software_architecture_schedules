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
