page 33020444 "Half Appraisal Card"
{
    //     On Open Page Check the UserID for Appraising
    //     On PostAndNotify Action : Calculate the Total Appraisal Marks 1 and notify Appraiser 2

    PageType = Card;
    SourceTable = Table33020361;

    layout
    {
        area(content)
        {
            group(Employee)
            {
                Caption = 'Employee';
                field("Entry No."; "Entry No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field(Name; Name)
                {
                }
                field(Designation; Designation)
                {
                }
                field(Department; Department)
                {
                }
                field("Join Date"; "Join Date")
                {
                }
                field("Level/Grade"; "Level/Grade")
                {
                }
                field(Branch; Branch)
                {
                }
                field("Last Promotion Date"; "Last Promotion Date")
                {
                }
                field("LastPromotion Years 1"; "LastPromotion Years 1")
                {
                    Caption = 'No. of years in Present Grade';
                    Editable = false;
                }
                field(Qualification; Qualification)
                {
                }
                field("Appraisal Type"; "Appraisal Type")
                {
                    Editable = false;
                }
                field("Promotion Type"; "Promotion Type")
                {
                }
            }
            group(General)
            {
                Caption = 'This section is filled by 1st Appraisal';
                Visible = false;
                field("Appraiser 1"; "Appraiser 1")
                {
                    Editable = false;
                }
                field("Appraiser 1 Name"; "Appraiser 1 Name")
                {
                    Editable = false;
                }
                field("Appraiser 1 Designation"; "Appraiser 1 Designation")
                {
                    Caption = 'Designation';
                    Editable = false;
                }
                field("Nature of Work"; "Nature of Work")
                {
                    Caption = 'Nature of work done';
                    MultiLine = true;
                }
                field(Strength; Strength)
                {
                }
                field(Weakness; Weakness)
                {
                }
                field("Post Appraisal Counseling"; "Post Appraisal Counseling")
                {
                    MultiLine = true;
                }
                field(Integrity; Integrity)
                {
                }
            }
            group("Rating Criterion Matrix")
            {
                Caption = 'Rating Criterion Matrix';
                Visible = false;
                fixed()
                {
                    Visible = false;
                    group()
                    {
                        Visible = false;
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(Text002; Text002)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(Text003; Text003)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(Text004; Text004)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(Text005; Text005)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                    }
                }
                fixed()
                {
                    Visible = false;
                    group()
                    {
                        Visible = false;
                        field(Text010; Text010)
                        {
                        }
                        field(Text011; Text011)
                        {
                        }
                        field(Text012; Text012)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(Text013; Text013)
                        {
                        }
                        field(Text014; Text014)
                        {
                        }
                        field(Text015; Text015)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(Text016; Text016)
                        {
                        }
                        field(Text017; Text017)
                        {
                        }
                        field(Text018; Text018)
                        {
                        }
                        field(TextBlank; TextBlank)
                        {
                        }
                        field(Text019; Text019)
                        {
                        }
                        field(Text020; Text020)
                        {
                        }
                        field(Text021; Text021)
                        {
                        }
                    }
                }
            }
            group("Knowledge & Performance")
            {
                Caption = 'Knowledge & Performance - [Weightage(X)=3] [Rating Scale(Y1), Very Good=4, Good=3, Satisfactory=2, Barely Adequate=1] [Total Score (Z1)=(X*Y1)]';
                Visible = false;
                field(KnowledgeSkill1; KnowledgeSkill1)
                {
                    Caption = 'Knowledge & Skills Ù Possession knowledge & skills and its updating ability in applying knowledge to carry out his work';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field(QOW1; QOW1)
                {
                    Caption = 'Quality of work Ù Accuracy, clarity and excellence of output, systematic nature of work';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("CostConsc.1"; "CostConsc.1")
                {
                    Caption = 'Cost Consciousness Ù Efforts towards optimum utilization of available resources ';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
            }
            group("_Knowledge & Performance")
            {
                Caption = 'Knowledge & Performance - [Weightage(X)=2] [Rating Scale(Y1), Very Good=4, Good=3, Satisfactory=2, Barely Adequate=1] [Total Score (Z1)=(X*Y1)]';
                Visible = false;
                field("Professional Ability 1"; "Professional Ability 1")
                {
                    Caption = 'Professional Ability - Possession of professional knowledge & skills and its updating ability in applying professional knowledge to carry out tasks';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Job Responsibility 1"; "Job Responsibility 1")
                {
                    Caption = 'Job Responsibility Ù Meeting targets, shouldering responsibility, understanding all phases of work, extent of follow-up required';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("QOW1>"; QOW1)
                {
                    Caption = 'Quality of work  Ù Thoroughness, accuracy, clarity and general excellence of output, extent of work free from errors, consistency of output, systematic nature of work';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("CostConsc.1>"; "CostConsc.1")
                {
                    Caption = 'Cost Consciousness Ù Efforts towards optimum utilization of available resources and elimination of waste';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
            }
            group("Personal Attributes")
            {
                Caption = 'Personal Attributes - [Rating Scale(Y1), Very Good=4, Good=3, Satisfactory=2, Barely Adequate=1] [Total Score (Z1)=(X*Y1)]';
                Visible = false;
                field(Attitude1; Attitude1)
                {
                    Caption = 'Positive Attitude  [Weightage(X)=2] Ù Degree of interest in work, desire to gain knowledge about own job and related jobs';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field(Initiative1; Initiative1)
                {
                    Caption = 'Initiative  [Weightage(X)=1] Ù Ability to be self reliant and resourceful, ability to carry out task without outside guidance ';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field(Discipline1; Discipline1)
                {
                    Caption = 'Discipline  [Weightage(X)=2] Ù Adherence to expected standards of conduct, following instructions, punctuality & responsibility';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
            }
            group("_Personal Attributes")
            {
                Caption = 'Personal Attributes - [Weightage(X)=1] [Rating Scale(Y1), Very Good=4, Good=3, Satisfactory=2, Barely Adequate=1] [Total Score (Z1)=(X*Y1)]';
                Visible = false;
                field("Attitude1>"; Attitude1)
                {
                    Caption = 'Positive Attitude Ù Degree of interest in work, recognizing opportunity, desire to gain knowledge about own job and related jobs';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Initiative1>"; Initiative1)
                {
                    Caption = 'Initiative Ù Willingness to assume responsibilities, displaying vigor in carrying out tasks, ability to be self reliant and resourceful, ability to carry out task without outside guidance ';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Innovative Thinking 1"; "Innovative Thinking 1")
                {
                    Caption = 'Innovative Thinking Ù Generation of ideas, grasping problems and evolving relevant solutions';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Communication 1"; "Communication 1")
                {
                    Caption = 'Communication Ù Skills to give and receive instructions accurately, ability to present issues lucidly, sharing information with all concerned';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Interpersonal Relations 1"; "Interpersonal Relations 1")
                {
                    Caption = 'Interpersonal Relations Ù Attitude and degree of cooperation with colleagues, subordinates and seniors, adaptability to new situations, contributions as a Team member, application of problem solving skills to settle differences with others, consistent with organizational objective';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Discipline1>"; Discipline1)
                {
                    Caption = 'Discipline Ù Adherence to expected standards of conduct, following instructions, instilling sense of discipline in subordinates, punctuality & responsibility';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
            }
            group("Management Attributes")
            {
                Caption = 'Management Attributes - [Weightage(X)=3] [Rating Scale(Y1), Very Good=4, Good=3, Satisfactory=2, Barely Adequate=1] [Total Score (Z1)=(X*Y1)]';
                Visible = false;
                field("Planning n Org1"; "Planning n Org1")
                {
                    Caption = 'Planning & Organization Ù Planning and setting priorities, understanding objectives and developing realistic and workable plans';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Decision Making1"; "Decision Making1")
                {
                    Caption = 'Decision Making Ù Ability to grasp problems and take timely decisions';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
            }
            group("_Management Attributes")
            {
                Caption = 'Management Attributes - [Weightage(X)=2] [Rating Scale(Y1), Very Good=4, Good=3, Satisfactory=2, Barely Adequate=1] [Total Score (Z1)=(X*Y1)]';
                Visible = false;
                field("Planning n Org1>"; "Planning n Org1")
                {
                    Caption = 'Planning & Organization Ù Planning ahead, setting priorities, understanding objectives and developing realistic and workable plans, developing work teams, distributing & assigning work opportunity';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Decision Making1>"; "Decision Making1")
                {
                    Caption = 'Decision Making Ù Ability to grasp problems critically examine alternatives courses of action, take timely and sound decisions, willingness to take decisions and display foresight';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Leadership 1"; "Leadership 1")
                {
                    Caption = 'Leadership Ù Ability to motivate others, sensitivity to needs and problems of others acceptance by group.';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
            }
            group("Appraisal Criteria")
            {
                Caption = 'Appraisal Criteria';
                Visible = false;
                field("KnowledgeSkill1>"; KnowledgeSkill1)
                {
                    Caption = 'KnowledgeSkill1';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Quantity Wise 1"; "Quantity Wise 1")
                {

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Fastest 1"; "Fastest 1")
                {

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Accuracy 1"; "Accuracy 1")
                {

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Clarity 1"; "Clarity 1")
                {

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Attendance 1"; "Attendance 1")
                {

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Follow Rules 1"; "Follow Rules 1")
                {

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field(_Initiative1; Initiative1)
                {
                    Caption = 'Initiative1';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Punctual & Responsible 1"; "Punctual & Responsible 1")
                {

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Helpfulness 1"; "Helpfulness 1")
                {

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("-CostConsc.1"; "CostConsc.1")
                {
                    Caption = 'CostConsc.1';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Freindly 1"; "Freindly 1")
                {

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("-Interpersonal Relations 1>"; "Interpersonal Relations 1")
                {
                    Caption = 'Interpersonal Relations 1';

                    trigger OnValidate()
                    begin
                        "Total App1" := CalculateAppraisalScore;
                    end;
                }
                field("Recommended For Promotion"; "Recommended For Promotion")
                {
                }
                field("Training Needs"; "Training Needs")
                {
                }
            }
            group("Appraisal Question")
            {
                Caption = 'Appraisal Question';
                part("<Appraisal Question Subfrom>"; 33019859)
                {
                    Caption = '<Appraisal Question Subfrom>';
                    SubPageLink = No.=FIELD(Entry No.),
                                  Appraisal Type=FIELD(Apprisal Type),
                                  Department=FIELD(Department);
                }
            }
            group("Objective Review")
            {
                Caption = 'Objective Review';
                Visible = false;
                part(;33020308)
                {
                    SubPageLink = Employee Code=FIELD(Employee Code),
                                  Fiscal Year=FILTER(<>Fiscal Year);
                    Visible = false;
                }
            }
            group("Objectives & Tasks")
            {
                Caption = 'Objectives & Tasks Done';
                Visible = false;
                part("Objective To be Done";33020307)
                {
                    Caption = 'Objective To be Done';
                    SubPageLink = Employee Code=FIELD(Employee Code),
                                  Fiscal Year=FIELD(Fiscal Year);
                }
            }
            group("Objectives to be Done")
            {
                Caption = 'Objectives to be Done';
                Visible = false;
            }
            part(;33020380)
            {
                SubPageLink = Employee Code=FIELD(Employee Code);
                Visible = false;
            }
            part("Training Needs";33020439)
            {
                Caption = 'Training Needs';
                SubPageLink = Employee Code=FIELD(Employee Code);
            }
            group(Total)
            {
                Caption = 'Total';
                field("Total Average";"Total Average")
                {
                    Editable = false;
                }
                field("Remarks I";"Remarks I")
                {
                    Caption = 'General Remarks by 1st Appraiser';
                    MultiLine = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1102159047>")
            {
                Caption = 'Post';
                Image = ExportSalesPerson;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Appraisal: Record "33020361";
                    AppQuestList: Record "33019826";
                    TotalPercent: Decimal;
                    TotalMarks: Decimal;
                    MarkObtain: Decimal;
                begin
                    MESSAGE('post');
                    /*Calendar.SETRANGE(Calendar."English Date",TODAY);
                    IF Calendar.FIND('-') THEN
                      "Fiscal Year" := Calendar."Fiscal Year";*/
                    
                    Appraisal.SETRANGE("Employee Code","Employee Code");
                    Appraisal.SETRANGE(Appraisal."Fiscal Year","Fiscal Year");
                    IF Appraisal.FIND('-') THEN BEGIN
                      IF (Appraisal.IsAppraised1 = TRUE) THEN BEGIN
                       // ERROR(Text001)
                        "Total App1" := CalculateAppraisalScore;
                        MESSAGE('Modification is done.');
                      END ELSE BEGIN
                    
                        MESSAGE('Notification Send');
                        "Total App1" := CalculateAppraisalScore;
                        IsAppraised1 := TRUE;
                        "Appraisal 1 UserID" := USERID;
                        "Appraised 1 Date" := TODAY;
                        //"Appraised By" := "Appraised By"::"1";
                        MESSAGE('First Appraisal done successfully.');
                      END;
                      /*CLEAR(TotalMarks);
                      CLEAR(MarkObtain);
                      AppQuestList.RESET;
                      AppQuestList.SETRANGE("No.", Appraisal."Entry No.");
                      IF AppQuestList.FINDSET THEN
                      REPEAT
                        TotalMarks += AppQuestList."Total Marks";
                        MarkObtain += AppQuestList."Marks Obtained"
                      UNTIL AppQuestList.NEXT = 0;
                      Appraisal."Overall Rating" := (MarkObtain/TotalMarks) * 100;
                      Appraisal.MODIFY;*/
                    END;

                end;
            }
            action("<Action1000000057>")
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Appraisal.RESET;
                    Appraisal.SETRANGE(Appraisal."Employee Code","Employee Code");
                    Appraisal.SETRANGE(Appraisal."Entry No.","Entry No.");
                    IF Appraisal.FINDFIRST THEN BEGIN
                       Appraisal.SETRANGE(Appraisal.Category,'CAT-1');
                       IF Appraisal.FINDFIRST THEN
                          REPORT.RUNMODAL(33020330,TRUE,FALSE,Appraisal);
                       Appraisal.SETRANGE(Appraisal.Category,'CAT-2');
                       IF Appraisal.FINDFIRST THEN
                          REPORT.RUNMODAL(33020331,TRUE,FALSE,Appraisal);

                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Appraisal.SETRANGE(Appraisal."Employee Code","Employee Code");
        IF Appraisal.FIND('-') THEN BEGIN

           Grades.SETRANGE(Grades."Grade Code",Appraisal."Level/Grade");
           IF Grades.FIND('-') THEN BEGIN
              Category := Grades.Category;

              IF Category = 'CAT-1' THEN BEGIN
                 KnowledgeTab := TRUE;
                 PersonalTab := TRUE;
                 ManagementTab := TRUE;
                 KnowledgeTab1 := FALSE;
                 PersonalTab1 := FALSE;
                 ManagementTab1 := FALSE;
                 AppraisalCriteria := FALSE;
              END;
              IF Category = 'CAT-2' THEN BEGIN
                 KnowledgeTab1 := TRUE;
                 PersonalTab1 := TRUE;
                 ManagementTab1 := TRUE;
                 KnowledgeTab := FALSE;
                 PersonalTab := FALSE;
                 ManagementTab := FALSE;
                 AppraisalCriteria := FALSE;
              END;
              IF Category = 'CAT-3' THEN BEGIN
                 KnowledgeTab1 := FALSE;
                 PersonalTab1 := FALSE;
                 ManagementTab1 := FALSE;
                 KnowledgeTab := FALSE;
                 PersonalTab := FALSE;
                 ManagementTab := FALSE;
                 AppraisalCriteria := TRUE;
              END;

           END;
        END;
    end;

    var
        EmpRec: Record "5200";
        KnowledgeAndSkill: Integer;
        QOW: Integer;
        CostConsc: Integer;
        Attitude: Integer;
        Initiative: Integer;
        Discipline: Integer;
        Planning: Integer;
        DecisionMk: Integer;
        Total: Integer;
        Calendar: Record "33020302";
        Appraisal: Record "33020361";
        Text001: Label 'Appraisal for the selected employee is already done for this Fiscal Year';
        [InDataSet]
        KnowledgeTab: Boolean;
        [InDataSet]
        PersonalTab: Boolean;
        [InDataSet]
        ManagementTab: Boolean;
        Grades: Record "33020324";
        [InDataSet]
        KnowledgeTab1: Boolean;
        [InDataSet]
        PersonalTab1: Boolean;
        [InDataSet]
        ManagementTab1: Boolean;
        ProfessionalAbility: Integer;
        JobResponsibility: Integer;
        InnovativeThinking: Integer;
        Communication: Integer;
        InterPersonalRelation: Integer;
        Leadership: Integer;
        Category: Code[10];
        [InDataSet]
        AppraisalCriteria: Boolean;
        Quantity: Integer;
        Fastest: Integer;
        Accuracy: Integer;
        Clarity: Integer;
        Attendance: Integer;
        FollowRules: Integer;
        Punctual: Integer;
        Helpful: Integer;
        Friendly: Integer;
        FirstAppraisarID: Code[20];
        FirstAppraisalName: Text[50];
        EmpTrainingNeed: Record "33020400";
        Text002: Label 'Very Good (4)';
        Text003: Label 'Good (3)';
        Text004: Label 'Satisfactory (2)';
        Text005: Label 'Below Average (1)';
        TextBlank: ;
        Text010: Label 'Achieves >=100% of given target, normal situation';
        Text011: Label 'Always meets commitment in terms of meeting deadlines despite constraints';
        Text012: Label 'Excellent work quality: Rarely makes error and doesnÙt repeat them';
        Text013: Label 'Achieves 61% Ù 99% of given target, in easy situation';
        Text014: Label 'Misses out on deadlines rarely even without constraints';
        Text015: Label 'Makes very few errors and does not repeat them';
        Text016: Label 'Achieves 41% - 60% of given target, in very easy situation';
        Text017: Label 'Misses out on deadlines sometimes ';
        Text018: Label 'Makes some errors and does not repeat them';
        Text019: Label 'Achieves <= 40% of given target, in very easy situation';
        Text020: Label 'Misses out on deadlines most of the times';
        Text021: Label 'Makes many errors and does not seem to have the drive or know how to do the job';
        ApprisalType: Option " ",Self,Manager,"Manager 360";

    [Scope('Internal')]
    procedure CalculateAppraisalScore(): Integer
    begin


        CASE KnowledgeSkill1 OF
           KnowledgeSkill1 :: "Very Good" :
             KnowledgeAndSkill := 4;
           KnowledgeSkill1 :: Good :
             KnowledgeAndSkill := 3;
           KnowledgeSkill1 :: Satisfactory :
             KnowledgeAndSkill := 2;
           KnowledgeSkill1 :: "Barely Adequate" :
             KnowledgeAndSkill := 1;
         END;


         CASE QOW1 OF
         QOW1 :: "Very Good" :
           QOW := 4;
         QOW1 :: Good :
           QOW := 3;
         QOW1 :: Satisfactory :
           QOW := 2;
         QOW1 :: "Barely Adequate" :
           QOW := 1;
         END;

         CASE "CostConsc.1" OF
           "CostConsc.1" :: "Very Good" :
            CostConsc := 4;
           "CostConsc.1" :: Good :
             CostConsc := 3;
          "CostConsc.1" :: Satisfactory :
             CostConsc := 2;
           "CostConsc.1" :: "Barely Adequate" :
             CostConsc := 1;
         END;

         CASE Attitude1 OF
           Attitude1 :: "Very Good" :
           Attitude := 4;
           Attitude1 :: Good :
             Attitude := 3;
           Attitude1 :: Satisfactory :
             Attitude := 2;
           Attitude1 :: "Barely Adequate" :
             Attitude := 1;
         END;

         CASE Initiative1 OF
           Initiative1 :: "Very Good" :
            Initiative := 4;
           Initiative1 :: Good :
             Initiative := 3;
           Initiative1 :: Satisfactory :
             Initiative := 2;
           Initiative1 :: "Barely Adequate" :
             Initiative := 1;
         END;

        CASE Discipline1 OF
           Discipline1 :: "Very Good" :
           Discipline := 4;
           Discipline1 :: Good :
             Discipline := 3;
           Discipline1 :: Satisfactory :
             Discipline := 2;
           Discipline1 :: "Barely Adequate" :
             Discipline := 1;
         END;

        CASE "Planning n Org1" OF
           "Planning n Org1" :: "Very Good" :
            Planning := 4;
           "Planning n Org1" :: Good :
             Planning := 3;
           "Planning n Org1" :: Satisfactory :
             Planning := 2;
           "Planning n Org1" :: "Barely Adequate" :
             Planning := 1;
         END;

        CASE "Decision Making1" OF
           "Decision Making1" :: "Very Good" :
            DecisionMk := 4;
           "Decision Making1" :: Good :
             DecisionMk := 3;
           "Decision Making1" :: Satisfactory :
             DecisionMk := 2;
           "Decision Making1" :: "Barely Adequate" :
             DecisionMk := 1;
         END;

        CASE "Professional Ability 1" OF
           "Professional Ability 1" :: "Very Good" :
              ProfessionalAbility := 4;
           "Professional Ability 1" :: Good :
             ProfessionalAbility := 3;
           "Professional Ability 1" :: Satisfactory :
             ProfessionalAbility := 2;
           "Professional Ability 1" :: "Barely Adequate" :
             ProfessionalAbility := 1;
         END;

        CASE "Job Responsibility 1" OF
           "Job Responsibility 1" :: "Very Good" :
              JobResponsibility := 4;
           "Job Responsibility 1" :: Good :
             JobResponsibility := 3;
           "Job Responsibility 1" :: Satisfactory :
             JobResponsibility := 2;
           "Job Responsibility 1" :: "Barely Adequate" :
             JobResponsibility := 1;
         END;

        CASE "Innovative Thinking 1" OF
           "Innovative Thinking 1" :: "Very Good" :
              InnovativeThinking := 4;
           "Innovative Thinking 1" :: Good :
             InnovativeThinking := 3;
           "Innovative Thinking 1" :: Satisfactory :
             InnovativeThinking := 2;
           "Innovative Thinking 1" :: "Barely Adequate" :
             InnovativeThinking := 1;
         END;

        CASE "Communication 1" OF
           "Communication 1" :: "Very Good" :
              Communication := 4;
           "Communication 1" :: Good :
             Communication := 3;
           "Communication 1" :: Satisfactory :
             Communication := 2;
           "Communication 1" :: "Barely Adequate" :
             Communication := 1;
         END;

        CASE "Interpersonal Relations 1" OF
           "Interpersonal Relations 1" :: "Very Good" :
             InterPersonalRelation := 4;
           "Interpersonal Relations 1" :: Good :
             InterPersonalRelation := 3;
           "Interpersonal Relations 1" :: Satisfactory :
             InterPersonalRelation := 2;
           "Interpersonal Relations 1" :: "Barely Adequate" :
             InterPersonalRelation := 1;
         END;

        CASE "Leadership 1" OF
           "Leadership 1" :: "Very Good" :
              Leadership := 4;
           "Leadership 1" :: Good :
             Leadership := 3;
           "Leadership 1" :: Satisfactory :
             Leadership := 2;
           "Leadership 1" :: "Barely Adequate" :
             Leadership := 1;
         END;

        CASE "Quantity Wise 1" OF
           "Quantity Wise 1" :: "Very Good" :
              Quantity := 4;
           "Quantity Wise 1" :: Good :
             Quantity := 3;
           "Quantity Wise 1" :: Satisfactory :
             Quantity := 2;
           "Quantity Wise 1" :: "Barely Adequate" :
             Quantity := 1;
         END;


        CASE "Fastest 1" OF
           "Fastest 1" :: "Very Good" :
              Fastest := 4;
           "Fastest 1" :: Good :
             Fastest := 3;
           "Fastest 1" :: Satisfactory :
             Fastest := 2;
           "Fastest 1" :: "Barely Adequate" :
             Fastest := 1;
         END;

        CASE "Accuracy 1" OF
           "Accuracy 1" :: "Very Good" :
              Accuracy := 4;
           "Accuracy 1" :: Good :
             Accuracy := 3;
           "Accuracy 1" :: Satisfactory :
             Accuracy := 2;
           "Accuracy 1" :: "Barely Adequate" :
             Accuracy := 1;
         END;

        CASE "Clarity 1" OF
           "Clarity 1" :: "Very Good" :
              Clarity := 4;
           "Clarity 1" :: Good :
             Clarity := 3;
           "Clarity 1" :: Satisfactory :
             Clarity := 2;
           "Clarity 1" :: "Barely Adequate" :
             Clarity := 1;
         END;

        CASE "Attendance 1" OF
           "Attendance 1" :: "Very Good" :
              Attendance := 4;
           "Attendance 1" :: Good :
             Attendance := 3;
           "Attendance 1" :: Satisfactory :
             Attendance := 2;
           "Attendance 1" :: "Barely Adequate" :
             Attendance := 1;
         END;

        CASE "Follow Rules 1" OF
           "Follow Rules 1" :: "Very Good" :
              FollowRules := 4;
           "Follow Rules 1" :: Good :
             FollowRules := 3;
           "Follow Rules 1" :: Satisfactory :
             FollowRules := 2;
           "Follow Rules 1" :: "Barely Adequate" :
             FollowRules := 1;
         END;

        CASE "Punctual & Responsible 1" OF
           "Punctual & Responsible 1" :: "Very Good" :
              Punctual := 4;
           "Punctual & Responsible 1" :: Good :
              Punctual := 3;
           "Punctual & Responsible 1" :: Satisfactory :
              Punctual := 2;
           "Punctual & Responsible 1" :: "Barely Adequate" :
              Punctual := 1;
         END;

        CASE "Helpfulness 1" OF
           "Helpfulness 1" :: "Very Good" :
              Helpful := 4;
           "Helpfulness 1" :: Good :
             Helpful := 3;
           "Helpfulness 1" :: Satisfactory :
             Helpful := 2;
           "Helpfulness 1" :: "Barely Adequate" :
             Helpful := 1;
         END;

        CASE "Freindly 1" OF
           "Freindly 1" :: "Very Good" :
              Friendly := 4;
           "Freindly 1" :: Good :
              Friendly := 3;
           "Freindly 1" :: Satisfactory :
              Friendly := 2;
           "Freindly 1" :: "Barely Adequate" :
              Friendly := 1;
         END;


        IF Category = 'CAT-2' THEN BEGIN
        Total :=(3 *(KnowledgeAndSkill+QOW+CostConsc)) + (2*(Attitude+Discipline))+Initiative+(3*(DecisionMk+Planning));
        EXIT(Total);
        END;
        IF Category = 'CAT-1' THEN BEGIN
        Total :=(2 *(ProfessionalAbility+JobResponsibility+QOW+CostConsc+Planning+DecisionMk+Leadership)) + Attitude + Initiative +
                 InnovativeThinking + Communication +InterPersonalRelation +Discipline;

        EXIT(Total);
        END;
        IF Category = 'CAT-3' THEN BEGIN
        Total :=(4 * KnowledgeAndSkill) + (2 * (Quantity + Accuracy + Attendance + CostConsc)) + Fastest + Clarity + Initiative +
                 FollowRules + Punctual + Helpful + Friendly +InterPersonalRelation;

        EXIT(Total);
        END;
    end;

    [Scope('Internal')]
    procedure setApprisalType(ApprisalType_: Option " ",Self,Manager,"Manager 360")
    begin
        ApprisalType := ApprisalType_;
    end;
}

