# Conceptual Entity-Relationship Diagram (ERD) for AFilearn

This document provides a high-level overview of the key entities and relationships within the AFilearn system. The ERD serves as a blueprint for understanding the data model and guiding the development process.

## Entities
1. **Student**
    
    Represents every student enrolled in the AFilearn platform

    Attributes:

    - Student ID (Primary key)
    - Gender 
    - Region
    - HighestEducation
    - IdmBand
    - AgeBand
    - IsDisabled
    - CreatedAt
    - UpdatedAt

2. **Module**

    Represents a learning module within the AFilearn platform

    Attributes:

    - Module ID (Primary key)
    - ModuleCode
    - CreatedAt
    - UpdatedAt

3. **Presentation**

    Represents a presentation of module within the AFilearn platform

    Attributes:

    - Presentation ID (Primary key)
    - Year
    - Semester
    - PresentationCode
    - CreatedAt
    - UpdatedAt

4. **Assessment**

    Represents an assessment within the AFilearn platform

    Attributes:

    - Assessment ID (Primary key)
    - Module ID (Foreign key)
    - Presentation ID (Foreign key)
    - AssessmentType
    - SubmissionDate_offset
    - AssessmentWeight

5. **StudentRegistration**

    Represents the registration of a student for a specific module presentation within the AFilearn platform

    Attributes:

    - Registration ID (Primary key)
    - Student ID (Foreign key)
    - Module ID (Foreign key)
    - Presentation ID (Foreign key)
    - NumberOfPrevAttempts
    - StudiedCredits
    - RegistrationDate_offset
    - UnregistrationDate_offset
    - FinalResult

6. **StudentAssessment**

    Represents the assessment results of a student for a specific module presentation within the AFilearn platform

    Attributes:

    - StudentAssessment ID (Primary key)
    - Student ID (Foreign key)
    - Assessment ID (Foreign key)
    - DateSubmitted_offset
    - IsBanked
    - Score

7. **ModulePresentation**

    Represents a specific offering of a module within a particular academic term

    Attributes:

    - ModulePresentation ID (Primary key)
    - Module ID (Foreign key)
    - Presentation ID (Foreign key)
    - ModulePresentationLength
    - CreatedAt
    - UpdatedAt

8. **VleActivityType**

    Represents a specific activity within a module presentation

    Attributes:

    - VleActivityTypeID (Primary key)
    - VleActivityName

9. **Vle**

    Represents a virtual learning environment resource within a module presentation

    Attributes:

    - VleID (Primary key)
    - ModuleID (Foreign key)
    - PresentationID (Foreign key)
    - ActivityTypeID (Foreign key)
    - WeekFrom
    - WeekTo

10. **StudentVle**

    Represents the association between a student and a virtual learning environment resource

    Attributes:

    - StudentVleID (Primary key)
    - StudentID (Foreign key)
    - VleID (Foreign key)
    - AccessDate_offset
    - NumberOfClicks
