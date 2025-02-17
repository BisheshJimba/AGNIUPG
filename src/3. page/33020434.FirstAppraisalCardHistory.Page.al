page 33020434 "First Appraisal Card History"
{
    //     On Open Page Check the UserID for Appraising
    //     On PostAndNotify Action : Calculate the Total Appraisal Marks 1 and notify Appraiser 2

    Editable = false;
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
                    Editable = false;
                }
                field("Employee Code"; "Employee Code")
                {
                    Editable = false;
                }
                field(Name; Name)
                {
                    Editable = false;
                }
                field(Designation; Designation)
                {
                    Editable = false;
                }
                field(Department; Department)
                {
                    Editable = false;
                }
                field("Join Date"; "Join Date")
                {
                    Editable = false;
                }
                field("Level/Grade"; "Level/Grade")
                {
                    Editable = false;
                }
                field(Branch; Branch)
                {
                    Editable = false;
                }
                field("Appraisal Type"; "Appraisal Type")
                {
                    Editable = false;
                }
            }
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("Appraiser 1"; "Appraiser 1")
                {
                }
                field("Appraiser 1 Name"; "Appraiser 1 Name")
                {
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
                field(CanConfirm; CanConfirm)
                {
                }
                field(ExtMonth; ExtMonth)
                {
                }
                field("Remarks I"; "Remarks I")
                {
                    MultiLine = true;
                }
            }
            group("Knowledge & Performance")
            {
                Caption = 'Knowledge & Performance';
                Editable = false;
                Visible = KnowledgeTab1;
                field(KnowledgeSkill1; KnowledgeSkill1)
                {
                    Caption = 'Knowledge & Skills';
                }
                field(QOW1; QOW1)
                {
                    Caption = 'Quality of work';
                }
                field("CostConsc.1"; "CostConsc.1")
                {
                    Caption = 'Cost Consciousness';
                }
            }
            group("_Knowledge & Performance")
            {
                Caption = 'Knowledge & Performance';
                Visible = KnowledgeTab;
                field("Professional Ability 1"; "Professional Ability 1")
                {
                    Caption = 'Professional Ability';
                }
                field("Job Responsibility 1"; "Job Responsibility 1")
                {
                    Caption = 'Job Responsibility';
                }
                field("QOW1>"; QOW1)
                {
                    Caption = 'Quality of work';
                }
                field("CostConsc.1>"; "CostConsc.1")
                {
                    Caption = 'Cost Consciousness';
                }
            }
            group("Personal Attributes")
            {
                Caption = 'Personal Attributes';
                Visible = PersonalTab1;
                field(Attitude1; Attitude1)
                {
                    Caption = 'Positive Attitude';
                }
                field(Initiative1; Initiative1)
                {
                    Caption = 'Initiative';
                }
                field(Discipline1; Discipline1)
                {
                    Caption = 'Discipline';
                }
            }
            group("_Personal Attributes")
            {
                Caption = 'Personal Attributes';
                Visible = PersonalTab;
                field("Attitude1>"; Attitude1)
                {
                    Caption = 'Positive Attitude';
                }
                field("Initiative1>"; Initiative1)
                {
                    Caption = 'Initiative';
                }
                field("Innovative Thinking 1"; "Innovative Thinking 1")
                {
                    Caption = 'Innovative Thinking';
                }
                field("Communication 1"; "Communication 1")
                {
                    Caption = 'Communication';
                }
                field("Interpersonal Relations 1"; "Interpersonal Relations 1")
                {
                    Caption = 'Interpersonal Relations';
                }
                field("Discipline1>"; Discipline1)
                {
                    Caption = 'Discipline';
                }
            }
            group("Management Attributes")
            {
                Caption = 'Management Attributes';
                Visible = ManagementTab1;
                field("Planning n Org1"; "Planning n Org1")
                {
                    Caption = 'Planning & Organization';
                }
                field("Decision Making1"; "Decision Making1")
                {
                    Caption = 'Decision Making';
                }
            }
            group("_Management Attributes")
            {
                Caption = 'Management Attributes';
                Visible = ManagementTab;
                field("Planning n Org1>"; "Planning n Org1")
                {
                    Caption = 'Planning & Organization';
                }
                field("Decision Making1>"; "Decision Making1")
                {
                    Caption = 'Decision Making';
                }
                field("Leadership 1"; "Leadership 1")
                {
                    Caption = 'Leadership';
                }
            }
            group("Appraisal Criteria")
            {
                Caption = 'Appraisal Criteria';
                Visible = AppraisalCriteria;
                field("KnowledgeSkill1>"; KnowledgeSkill1)
                {
                    Caption = 'KnowledgeSkill1';
                }
                field("Quantity Wise 1"; "Quantity Wise 1")
                {
                }
                field("Fastest 1"; "Fastest 1")
                {
                }
                field("Accuracy 1"; "Accuracy 1")
                {
                }
                field("Clarity 1"; "Clarity 1")
                {
                }
                field("Attendance 1"; "Attendance 1")
                {
                }
                field("Follow Rules 1"; "Follow Rules 1")
                {
                }
                field(_Initiative1; Initiative1)
                {
                    Caption = 'Initiative1';
                }
                field("Punctual & Responsible 1"; "Punctual & Responsible 1")
                {
                }
                field("Helpfulness 1"; "Helpfulness 1")
                {
                }
                field("CostConsc.1_"; "CostConsc.1")
                {
                    Caption = 'CostConsc.1';
                }
                field("Freindly 1"; "Freindly 1")
                {
                }
                field("_Interpersonal Relations 1>"; "Interpersonal Relations 1")
                {
                    Caption = 'Interpersonal Relations 1';
                }
            }
            group(Others)
            {
                Caption = 'Others';
                field("Total App1"; "Total App1")
                {
                    Caption = 'Total Marks';
                    Enabled = false;
                }
                field("Recommended For Promotion"; "Recommended For Promotion")
                {
                }
            }
            group("Objectives & Tasks")
            {
                Caption = 'Objectives & Tasks';
                field(Objectives; Objectives)
                {
                    MultiLine = true;
                }
                field("Remarks by 1st Appraiser"; "Remarks by 1st Appraiser")
                {
                    MultiLine = true;
                }
            }
            part(; 33020380)
            {
                SubPageLink = Employee Code=FIELD(Employee Code);
            }
            part("Training Needs"; 33020439)
            {
                Caption = 'Training Needs';
                Editable = false;
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000050>")
            {
                Caption = 'Second Appraisal Card';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020435;
                RunPageLink = Employee Code=FIELD(Employee Code);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Appraisal.SETRANGE(Appraisal."Employee Code","Employee Code");
        IF Appraisal.FIND('-') THEN BEGIN
           //MESSAGE('%1',Appraisal."Employee Code");
           //MESSAGE('%1',Appraisal."Level/Grade");
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
}

