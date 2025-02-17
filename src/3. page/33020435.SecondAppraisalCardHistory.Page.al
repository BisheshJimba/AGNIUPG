page 33020435 "Second Appraisal Card History"
{
    Editable = false;
    PageType = Card;
    SourceTable = Table33020361;

    layout
    {
        area(content)
        {
            group("Employee Info")
            {
                field("Entry No."; "Entry No.")
                {
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
                field(Branch; Branch)
                {
                }
                field("Appraisal Type"; "Appraisal Type")
                {
                }
                field("Overall Rating"; "Overall Rating")
                {
                    Editable = false;
                }
            }
            group(General)
            {
                Caption = 'General';
                field("Appraiser 2"; "Appraiser 2")
                {
                }
                field("Appraiser 2 Name"; "Appraiser 2 Name")
                {
                }
                field("Appraiser 2 Designation"; "Appraiser 2 Designation")
                {
                    Caption = 'Designation';
                    Editable = false;
                }
                field("Remarks II"; "Remarks II")
                {
                    Caption = 'Remarks';
                    MultiLine = true;
                }
            }
            group("Knowledge & Performance")
            {
                Caption = 'Knowledge & Performance';
                Visible = KnowledgeTab1;
                field(KnowledgeSkill2; KnowledgeSkill2)
                {
                    Caption = 'Knowledge & Skills';
                }
                field(QOW2; QOW2)
                {
                    Caption = 'Quality of work';
                }
                field("CostConsc.2"; "CostConsc.2")
                {
                    Caption = 'Cost Conciousness';
                }
            }
            group("_Knowledge & Performance")
            {
                Caption = 'Knowledge & Performance';
                Visible = KnowledgeTab;
                field("Professional Ability 2"; "Professional Ability 2")
                {
                    Caption = 'Professional Ability';
                }
                field("Job Responsibility 2"; "Job Responsibility 2")
                {
                    Caption = 'Job Responsibility';
                }
                field(_QOW2; QOW2)
                {
                    Caption = 'Quality of work';
                }
                field("_CostConsc.2"; "CostConsc.2")
                {
                    Caption = 'Cost Consciousness';
                }
            }
            group("Personal Attributes")
            {
                Caption = 'Personal Attributes';
                Visible = PersonalTab1;
                field(Attitude2; Attitude2)
                {
                    Caption = 'Positive Attitude';
                }
                field(Initiative2; Initiative2)
                {
                    Caption = 'Initiative';
                }
                field(Discipline2; Discipline2)
                {
                    Caption = 'Discipline';
                }
            }
            group("_Personal Attributes")
            {
                Caption = 'Personal Attributes';
                Visible = PersonalTab;
                field("_Attitude2>"; Attitude2)
                {
                    Caption = 'Positive Attitude';
                }
                field("_Initiative2>"; Initiative2)
                {
                    Caption = 'Initiative';
                }
                field("Innovative Thinking 2"; "Innovative Thinking 2")
                {
                    Caption = 'Innovative Thinking';
                }
                field("Communication 2"; "Communication 2")
                {
                    Caption = 'Communication';
                }
                field("Interpersonal Relations 2"; "Interpersonal Relations 2")
                {
                    Caption = 'Interpersonal Relations';
                }
                field("_Discipline2>"; Discipline2)
                {
                    Caption = 'Discipline';
                }
            }
            group("Management Attributes")
            {
                Caption = 'Management Attributes';
                Visible = ManagementTab1;
                field("Planning n Org2"; "Planning n Org2")
                {
                    Caption = 'Planning & Organizing';
                }
                field("Decision Making2"; "Decision Making2")
                {
                    Caption = 'Decision Making';
                }
            }
            group("_Management Attributes")
            {
                Caption = 'Management Attributes';
                Visible = ManagementTab;
                field("_Planning n Org2>"; "Planning n Org2")
                {
                    Caption = 'Planning & Organizing';
                }
                field("Decision Making2>"; "Decision Making2")
                {
                    Caption = 'Decision Making';
                }
                field("Leadership 2>"; "Leadership 2")
                {
                    Caption = 'Leadership';
                }
            }
            group("Appraisal Criteria")
            {
                Caption = 'Appraisal Criteria';
                Visible = AppraisalCriteria;
                field("KnowledgeSkill2>"; KnowledgeSkill2)
                {
                    Caption = 'KnowledgeSkill2';
                }
                field("Quantity Wise 2"; "Quantity Wise 2")
                {
                }
                field("Fastest 2"; "Fastest 2")
                {
                }
                field("Accuracy 2"; "Accuracy 2")
                {
                }
                field("Clarity 2"; "Clarity 2")
                {
                }
                field("Attendance 2"; "Attendance 2")
                {
                }
                field("Follow Rules 2"; "Follow Rules 2")
                {
                }
                field("Initiative2>"; Initiative2)
                {
                    Caption = 'Initiative2';
                }
                field("Punctual & Responsible 2"; "Punctual & Responsible 2")
                {
                }
                field("Helpfulness 2"; "Helpfulness 2")
                {
                }
                field("CostConsc.2>"; "CostConsc.2")
                {
                    Caption = 'CostConsc.2';
                }
                field("Freindly 2"; "Freindly 2")
                {
                }
                field("Interpersonal Relations 2>"; "Interpersonal Relations 2")
                {
                    Caption = 'Interpersonal Relations 2';
                }
            }
            group(Others)
            {
                Caption = 'Others';
                field("Total App2"; "Total App2")
                {
                    Editable = false;
                }
                field(Strength; Strength)
                {
                    Visible = false;
                }
                field(Weakness; Weakness)
                {
                    Visible = false;
                }
                field("Remarks by HR"; "Remarks by HR")
                {
                    MultiLine = true;
                }
                field("Recommended For Promotion"; "Recommended For Promotion")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Appraisal.SETRANGE(Appraisal."Employee Code", "Employee Code");
        IF Appraisal.FIND('-') THEN BEGIN
            //MESSAGE('%1',Appraisal."Employee Code");
            //MESSAGE('%1',Appraisal."Level/Grade");
            Grades.SETRANGE(Grades."Grade Code", Appraisal."Level/Grade");
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
        Appraisal: Record "33020361";
        [InDataSet]
        KnowledgeTab: Boolean;
        [InDataSet]
        PersonalTab: Boolean;
        [InDataSet]
        ManagementTab: Boolean;
        [InDataSet]
        KnowledgeTab1: Boolean;
        [InDataSet]
        PersonalTab1: Boolean;
        [InDataSet]
        ManagementTab1: Boolean;
        Grades: Record "33020324";
        Category: Code[10];
        ProfessionalAbility: Integer;
        JobResponsibility: Integer;
        InnovativeThinking: Integer;
        Communication: Integer;
        InterPersonalRelation: Integer;
        Leadership: Integer;
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
        GTotal: Decimal;
        OverallRating: Char;

    [Scope('Internal')]
    procedure CalculateAppraisalScore(): Integer
    begin
        CASE KnowledgeSkill2 OF
            KnowledgeSkill2::"Very Good":
                KnowledgeAndSkill := 4;
            KnowledgeSkill2::Good:
                KnowledgeAndSkill := 3;
            KnowledgeSkill2::Satisfactory:
                KnowledgeAndSkill := 2;
            KnowledgeSkill2::"Barely Adequate":
                KnowledgeAndSkill := 1;
        END;


        CASE QOW2 OF
            QOW2::"Very Good":
                QOW := 4;
            QOW2::Good:
                QOW := 3;
            QOW2::Satisfactory:
                QOW := 2;
            QOW2::"Barely Adequate":
                QOW := 1;
        END;

        CASE "CostConsc.2" OF
            "CostConsc.2"::"Very Good":
                CostConsc := 4;
            "CostConsc.2"::Good:
                CostConsc := 3;
            "CostConsc.2"::Satisfactory:
                CostConsc := 2;
            "CostConsc.2"::"Barely Adequate":
                CostConsc := 1;
        END;

        CASE Attitude2 OF
            Attitude2::"Very Good":
                Attitude := 4;
            Attitude2::Good:
                Attitude := 3;
            Attitude2::Satisfactory:
                Attitude := 2;
            Attitude2::"Barely Adequate":
                Attitude := 1;
        END;

        CASE Initiative2 OF
            Initiative2::"Very Good":
                Initiative := 4;
            Initiative2::Good:
                Initiative := 3;
            Initiative2::Satisfactory:
                Initiative := 2;
            Initiative2::"Barely Adequate":
                Initiative := 1;
        END;

        CASE Discipline2 OF
            Discipline2::"Very Good":
                Discipline := 4;
            Discipline2::Good:
                Discipline := 3;
            Discipline2::Satisfactory:
                Discipline := 2;
            Discipline2::"Barely Adequate":
                Discipline := 1;
        END;

        CASE "Planning n Org2" OF
            "Planning n Org2"::"Very Good":
                Planning := 4;
            "Planning n Org2"::Good:
                Planning := 3;
            "Planning n Org2"::Satisfactory:
                Planning := 2;
            "Planning n Org2"::"Barely Adequate":
                Planning := 1;
        END;

        CASE "Decision Making2" OF
            "Decision Making2"::"Very Good":
                DecisionMk := 4;
            "Decision Making2"::Good:
                DecisionMk := 3;
            "Decision Making2"::Satisfactory:
                DecisionMk := 2;
            "Decision Making2"::"Barely Adequate":
                DecisionMk := 1;
        END;

        CASE "Professional Ability 2" OF
            "Professional Ability 2"::"Very Good":
                ProfessionalAbility := 4;
            "Professional Ability 2"::Good:
                ProfessionalAbility := 3;
            "Professional Ability 2"::Satisfactory:
                ProfessionalAbility := 2;
            "Professional Ability 2"::"Barely Adequate":
                ProfessionalAbility := 1;
        END;

        CASE "Job Responsibility 2" OF
            "Job Responsibility 2"::"Very Good":
                JobResponsibility := 4;
            "Job Responsibility 2"::Good:
                JobResponsibility := 3;
            "Job Responsibility 2"::Satisfactory:
                JobResponsibility := 2;
            "Job Responsibility 2"::"Barely Adequate":
                JobResponsibility := 1;
        END;

        CASE "Innovative Thinking 2" OF
            "Innovative Thinking 2"::"Very Good":
                InnovativeThinking := 4;
            "Innovative Thinking 2"::Good:
                InnovativeThinking := 3;
            "Innovative Thinking 2"::Satisfactory:
                InnovativeThinking := 2;
            "Innovative Thinking 2"::"Barely Adequate":
                InnovativeThinking := 1;
        END;

        CASE "Communication 2" OF
            "Communication 2"::"Very Good":
                Communication := 4;
            "Communication 2"::Good:
                Communication := 3;
            "Communication 2"::Satisfactory:
                Communication := 2;
            "Communication 2"::"Barely Adequate":
                Communication := 1;
        END;

        CASE "Interpersonal Relations 2" OF
            "Interpersonal Relations 2"::"Very Good":
                InterPersonalRelation := 4;
            "Interpersonal Relations 2"::Good:
                InterPersonalRelation := 3;
            "Interpersonal Relations 2"::Satisfactory:
                InterPersonalRelation := 2;
            "Interpersonal Relations 2"::"Barely Adequate":
                InterPersonalRelation := 1;
        END;

        CASE "Leadership 2" OF
            "Leadership 2"::"Very Good":
                Leadership := 4;
            "Leadership 2"::Good:
                Leadership := 3;
            "Leadership 2"::Satisfactory:
                Leadership := 2;
            "Leadership 2"::"Barely Adequate":
                Leadership := 1;
        END;

        CASE "Quantity Wise 2" OF
            "Quantity Wise 2"::"Very Good":
                Quantity := 4;
            "Quantity Wise 2"::Good:
                Quantity := 3;
            "Quantity Wise 2"::Satisfactory:
                Quantity := 2;
            "Quantity Wise 2"::"Barely Adequate":
                Quantity := 1;
        END;


        CASE "Fastest 2" OF
            "Fastest 2"::"Very Good":
                Fastest := 4;
            "Fastest 2"::Good:
                Fastest := 3;
            "Fastest 2"::Satisfactory:
                Fastest := 2;
            "Fastest 2"::"Barely Adequate":
                Fastest := 1;
        END;

        CASE "Accuracy 2" OF
            "Accuracy 2"::"Very Good":
                Accuracy := 4;
            "Accuracy 2"::Good:
                Accuracy := 3;
            "Accuracy 2"::Satisfactory:
                Accuracy := 2;
            "Accuracy 2"::"Barely Adequate":
                Accuracy := 1;
        END;

        CASE "Clarity 2" OF
            "Clarity 2"::"Very Good":
                Clarity := 4;
            "Clarity 2"::Good:
                Clarity := 3;
            "Clarity 2"::Satisfactory:
                Clarity := 2;
            "Clarity 2"::"Barely Adequate":
                Clarity := 1;
        END;

        CASE "Attendance 2" OF
            "Attendance 2"::"Very Good":
                Attendance := 4;
            "Attendance 2"::Good:
                Attendance := 3;
            "Attendance 2"::Satisfactory:
                Attendance := 2;
            "Attendance 2"::"Barely Adequate":
                Attendance := 1;
        END;

        CASE "Follow Rules 2" OF
            "Follow Rules 2"::"Very Good":
                FollowRules := 4;
            "Follow Rules 2"::Good:
                FollowRules := 3;
            "Follow Rules 2"::Satisfactory:
                FollowRules := 2;
            "Follow Rules 2"::"Barely Adequate":
                FollowRules := 1;
        END;

        CASE "Punctual & Responsible 2" OF
            "Punctual & Responsible 2"::"Very Good":
                Punctual := 4;
            "Punctual & Responsible 2"::Good:
                Punctual := 3;
            "Punctual & Responsible 2"::Satisfactory:
                Punctual := 2;
            "Punctual & Responsible 2"::"Barely Adequate":
                Punctual := 1;
        END;

        CASE "Helpfulness 2" OF
            "Helpfulness 2"::"Very Good":
                Helpful := 4;
            "Helpfulness 2"::Good:
                Helpful := 3;
            "Helpfulness 2"::Satisfactory:
                Helpful := 2;
            "Helpfulness 2"::"Barely Adequate":
                Helpful := 1;
        END;

        CASE "Freindly 2" OF
            "Freindly 2"::"Very Good":
                Friendly := 4;
            "Freindly 2"::Good:
                Friendly := 3;
            "Freindly 2"::Satisfactory:
                Friendly := 2;
            "Freindly 2"::"Barely Adequate":
                Friendly := 1;
        END;


        IF Category = 'CAT-2' THEN BEGIN
            Total := (3 * (KnowledgeAndSkill + QOW + CostConsc)) + (2 * (Attitude + Discipline)) + Initiative + (3 * (DecisionMk + Planning));
            EXIT(Total);
        END;
        IF Category = 'CAT-1' THEN BEGIN
            Total := (2 * (ProfessionalAbility + JobResponsibility + QOW + CostConsc + Planning + DecisionMk + Leadership)) + Attitude + Initiative +
                    InnovativeThinking + Communication + InterPersonalRelation + Discipline;

            EXIT(Total);
        END;
        IF Category = 'CAT-3' THEN BEGIN
            Total := (4 * KnowledgeAndSkill) + (2 * (Quantity + Accuracy + Attendance + CostConsc)) + Fastest + Clarity + Initiative +
                     FollowRules + Punctual + Helpful + Friendly + InterPersonalRelation;

            EXIT(Total);
        END;
    end;

    [Scope('Internal')]
    procedure CalculateOverallRating(): Char
    begin
        GTotal := 0;
        GTotal := (Appraisal."Total App1" + Appraisal."Total App2") / 2;
        IF ((GTotal >= 71) AND (GTotal <= 80)) THEN BEGIN
            "Overall Rating" := "Overall Rating"::A;
            OverallRating := "Overall Rating";
            EXIT(OverallRating);
        END ELSE
            IF ((GTotal >= 51) AND (GTotal <= 70)) THEN BEGIN
                "Overall Rating" := "Overall Rating"::B;
                OverallRating := "Overall Rating";
                EXIT(OverallRating);
            END ELSE
                IF ((GTotal >= 31) AND (GTotal <= 50)) THEN BEGIN
                    "Overall Rating" := "Overall Rating"::C;
                    OverallRating := "Overall Rating";
                    EXIT(OverallRating);
                END ELSE BEGIN
                    "Overall Rating" := "Overall Rating"::D;
                    OverallRating := "Overall Rating";
                    EXIT(OverallRating);
                END;
    end;
}

