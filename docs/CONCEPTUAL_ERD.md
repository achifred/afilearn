# Conceptual Entity-Relationship Diagram (ERD) for AFilearn

This document provides a high-level overview of the key entities and relationships within the AFilearn system. The ERD serves as a blueprint for understanding the data model and guiding the development process.

## Entities
1. **dim_students**
    
    Represents every student enrolled in the AFilearn platform

    Attributes:

    - Student ID (Primary key)
    - Gender 
    - Region
    - HighestEducation
    - IdmBand
    - LowerIdmBand
    - UpperIdmBand
    - AgeBand
    - LowerAgeBand
    - UpperAgeBand
    - StudiedCredits
    - IsDisabled
    - CreatedAt
    - UpdatedAt

2. **dim_Module**

    Represents a learning module within the AFilearn platform

    Attributes:

    - Module ID (Primary key)
    - ModuleCode
    - CreatedAt
    - UpdatedAt

3. **dim_module_presentations**

    Represents a presentation of module within the AFilearn platform

    Attributes:

    - Presentation ID (Primary key)
    - Module ID (Foreign key)
    - PresentationCode
    - ModulePresentationLength
    - CreatedAt
    - UpdatedAt

4. **dim_assessment**

    Represents an assessment within the AFilearn platform

    Attributes:

    - Assessment ID (Primary key)
    - ModulePresentation ID (Foreign key)
    - AssessmentType
    - SubmissionDate_offset
    - AssessmentWeight

5. **fact_student_registrations**

    Represents the registration of a student for a specific module presentation within the AFilearn platform

    Attributes:

    - Registration ID (Primary key)
    - Student ID (Foreign key)
    - ModulePresentation ID (Foreign key)
    - NumberOfPrevAttempts
    - RegistrationDate_offset
    - UnregistrationDate_offset
    - FinalResult

6. **fact_student_assessment**

    Represents the assessment results of a student for a specific module presentation within the AFilearn platform

    Attributes:

    - StudentAssessment ID (Primary key)
    - Student ID (Foreign key)
    - Assessment ID (Foreign key)
    - DateSubmitted_offset
    - IsBanked
    - Score


7. **dim_vle_activity_type**

    Represents a specific activity within a module presentation

    Attributes:

    - VleActivityTypeID (Primary key)
    - VleActivityName

8. **Dim_Vle**

    Represents a virtual learning environment resource within a module presentation

    Attributes:

    - VleID (Primary key)
    - ModulePresentationID (Foreign key)
    - ActivityTypeID (Foreign key)
    - WeekFrom
    - WeekTo

9. **Fact_StudentVle**

    Represents the association between a student and a virtual learning environment resource

    Attributes:

    - StudentVleID (Primary key)
    - StudentID (Foreign key)
    - VleID (Foreign key)
    - AccessDate_offset
    - NumberOfClicks

10. **Mart_Student_Performance**

    Represents a summary of student performance metrics

    Attributes:

    - StudentPerformanceID (Primary key)
    - StudentID (Foreign key)
    - ModulePresentationID (Foreign key)
    - TotalAssessment
    - AverageAssessmentScore
    - LowestAssessmentScore
    - HighestAssessmentScore
    - TotalVleClicks
    - FinalResult
    - IsPassed