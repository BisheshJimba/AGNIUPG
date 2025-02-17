table 33020361 Appraisal
{

    fields
    {
        field(1; "Entry No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Entry No." <> xRec."Entry No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Appraisal No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(10; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmployeeList.SETRANGE("No.", "Employee Code");
                IF EmployeeList.FIND('-') THEN BEGIN
                    Name := EmployeeList."Full Name";
                    Designation := EmployeeList."Job Title";
                    Department := EmployeeList."Department Code";
                    // Branch := EmployeeList.Branch;
                    "Appraiser 1" := EmployeeList."First Appraisal ID";
                    Qualification := EmployeeList.Designation;
                    //  MESSAGE(FORMAT("Appraiser 1"));
                END;

                EmployeeList.RESET;
                EmployeeList.SETRANGE("No.", "Appraiser 1");
                IF EmployeeList.FIND('-') THEN BEGIN
                    "Appraiser 1 Name" := EmployeeList."Full Name";
                    //  "Appraiser 2" := EmployeeList."Manager ID";
                    //  MESSAGE(FORMAT("Appraiser 2"));
                END;

                /*  EmployeeList.RESET;
                  EmployeeList.SETRANGE("No.","Appraiser 2") ;
                  IF EmployeeList.FIND('-') THEN BEGIN
                     "Appraiser 2 Name" := EmployeeList."Full Name";
                  END
                          */

                //UpdateApprisalFromAsPerDesignation(Department,"Entry No.",xRec.Department,"Appraisal Type");

            end;
        }
        field(11; Name; Text[30])
        {
        }
        field(12; Designation; Text[100])
        {
        }
        field(13; Department; Text[30])
        {
            TableRelation = "Location Master".Code;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                UpdateApprisalFromAsPerDesignation2(Department, "Entry No.", xRec.Department, "Appraisal Type");
            end;
        }
        field(14; Branch; Code[20])
        {
        }
        field(17; ADEndFiscal; Date)
        {
        }
        field(18; StartFiscalYear; Text[12])
        {
        }
        field(19; EndFiscalYear; Text[12])
        {
        }
        field(20; "Appraiser 1"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                //sm to get Appraisal Name bases on No.
                EmployeeList.SETRANGE(EmployeeList."No.", "Appraiser 1");
                IF EmployeeList.FIND('-') THEN BEGIN
                    "Appraiser 1 Name" := EmployeeList."Full Name";
                    "Appraiser 1 Designation" := EmployeeList."Job Title";
                END;
            end;
        }
        field(22; "Appraiser 1 Name"; Text[90])
        {
            Editable = false;
            TableRelation = Employee."Full Name" WHERE(No.=FIELD(Appraiser 1));
        }
        field(23;"No. of years in Service Period";Text[30])
        {
        }
        field(24;"Total Experience outside";Decimal)
        {
        }
        field(30;"Appraiser 2";Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                 //sm to get Appraisal Name bases on No.
                  EmployeeList.SETRANGE(EmployeeList."No.","Appraiser 2");
                 IF EmployeeList.FIND('-') THEN BEGIN
                    "Appraiser 2 Name" := EmployeeList."Full Name";
                    "Appraiser 2 Designation" := EmployeeList."Job Title";
                 END;
            end;
        }
        field(32;"Appraiser 2 Name";Text[90])
        {
            Editable = false;
            TableRelation = Employee."Full Name" WHERE (No.=FIELD(Appraiser 2));
        }
        field(38;"Professional Ability 1";Option)
        {
            OptionCaption = ' ,Very Good,Good,Satisfactory,Barely Adequate';
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(39;"Job Responsibility 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(40;KnowledgeSkill1;Option)
        {
            Editable = true;
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(41;QOW1;Option)
        {
            Editable = true;
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(42;"CostConsc.1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(43;Attitude1;Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(44;Initiative1;Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(45;Discipline1;Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(46;"Planning n Org1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(47;"Decision Making1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(48;"Total App1";Integer)
        {
        }
        field(49;"Post Appraisal Counseling";Text[250])
        {
        }
        field(50;"Recommended For Promotion";Boolean)
        {
        }
        field(51;KnowledgeSkill2;Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(52;QOW2;Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(53;"CostConsc.2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(54;Attitude2;Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(55;Initiative2;Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(56;Discipline2;Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(57;"Planning n Org2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(58;"Decision Making2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(59;"Total App2";Integer)
        {

            trigger OnValidate()
            begin
                /*
                Total := 0;
                Total := ( "Total App1" + "Total App2" ) / 2;
                
                IF((Total >= 71) AND (Total <= 80)) THEN
                  "Overall Rating" := "Overall Rating"::A;
                IF((Total >= 51) AND (Total <= 70)) THEN
                  "Overall Rating" := "Overall Rating"::B;
                IF((Total >= 31) AND (Total <= 50)) THEN
                  "Overall Rating" := "Overall Rating"::C;
                IF((Total >= 0) AND (Total <= 30)) THEN
                  "Overall Rating" := "Overall Rating"::D;
                */

            end;
        }
        field(70;"Overall Rating";Option)
        {
            OptionMembers = " ",A,B,C,D;
        }
        field(73;Strength;Option)
        {
            OptionMembers = " ","Far below requirement","Below requirement","Meets requirement","Exceeds requirement","Far exceeds requirement";
        }
        field(75;Weakness;Option)
        {
            OptionMembers = " ","Far below requirement","Below requirement","Meets requirement","Exceeds requirement","Far exceeds requirement";
        }
        field(77;Integrity;Option)
        {
            OptionMembers = " ","Far below requirement","Below requirement","Meets requirement","Exceeds requirement","Far exceeds requirement";
        }
        field(79;"Remarks I";Text[250])
        {
        }
        field(80;"Remarks II";Text[250])
        {
        }
        field(91;"Remarks by HR";Text[250])
        {
        }
        field(100;"Training Needs";Text[100])
        {
        }
        field(110;CanConfirm;Boolean)
        {
        }
        field(111;ExtMonth;Integer)
        {
        }
        field(112;IsAppraised1;Boolean)
        {
        }
        field(113;IsAppraised2;Boolean)
        {
        }
        field(114;"Appraised 1 Date";Date)
        {
        }
        field(115;"Appraised 2 Date";Date)
        {
        }
        field(116;"Appraisal Type";Option)
        {
            OptionMembers = " ",Annual,"Half-Annual",Probational;
        }
        field(118;"Fiscal Year";Code[10])
        {
        }
        field(119;"No. Series";Code[20])
        {
        }
        field(120;"Innovative Thinking 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(121;"Communication 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(122;"Interpersonal Relations 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(123;"Leadership 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(124;Promotion;Boolean)
        {
        }
        field(125;"Join Date";Date)
        {
            FieldClass = Normal;
        }
        field(126;"Level/Grade";Code[10])
        {
            TableRelation = Grades."Grade Code";
        }
        field(127;"Nature of Work";Text[250])
        {
        }
        field(128;Objectives;Text[250])
        {
        }
        field(129;"Remarks by 1st Appraiser";Text[250])
        {
        }
        field(130;"Professional Ability 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(131;"Job Responsibility 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(132;"Innovative Thinking 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(133;"Communication 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(134;"Interpersonal Relations 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(135;"Leadership 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(136;"Quantity Wise 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(137;"Fastest 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(138;"Accuracy 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(139;"Clarity 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(140;"Attendance 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(141;"Follow Rules 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(142;"Punctual & Responsible 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(143;"Helpfulness 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(144;"Freindly 1";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(145;"Quantity Wise 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(146;"Fastest 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(147;"Accuracy 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(148;"Clarity 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(149;"Attendance 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(150;"Follow Rules 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(151;"Punctual & Responsible 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(152;"Helpfulness 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(153;"Freindly 2";Option)
        {
            OptionMembers = " ","Very Good",Good,Satisfactory,"Barely Adequate";
        }
        field(154;Selected;Boolean)
        {
        }
        field(155;"Last Promotion Date";Date)
        {
        }
        field(157;Qualification;Text[100])
        {
            FieldClass = Normal;
        }
        field(158;"Function";Text[250])
        {
        }
        field(159;"Appraiser 1 Designation";Text[100])
        {
        }
        field(160;"Appraiser 2 Designation";Text[100])
        {
        }
        field(161;Category;Code[50])
        {
            CalcFormula = Lookup("Job Title".Category WHERE (Description=FIELD(Designation)));
            FieldClass = FlowField;
        }
        field(163;"Remarks By Appraiser 1";Text[200])
        {
        }
        field(164;"Joint Years";Integer)
        {
        }
        field(165;"Joint Months";Integer)
        {
        }
        field(166;"Joint Days";Integer)
        {
        }
        field(167;"LastPromotion Years 1";Text[30])
        {
        }
        field(168;"Appraisal 1 UserID";Text[30])
        {
        }
        field(169;"Appraisal 2 UserID";Text[30])
        {
        }
        field(170;"Apprisal Type";Option)
        {
            OptionMembers = " ",Self,Manager,"Manger 360";

            trigger OnValidate()
            begin
                UpdateApprisalFromAsPerDesignation2(Department,"Entry No.",xRec.Department,ApprisalTypeG); // apprisal type wise question
            end;
        }
        field(171;"Promotion Type";Option)
        {
            OptionMembers = " ","Steo Promotion","Level Promotion";
        }
        field(172;"Total Average";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Employee Code","Fiscal Year","Appraisal Type")
        {
        }
        key(Key3;"Employee Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        IF "Entry No." = '' THEN BEGIN
          HRSetup.GET;
          HRSetup.TESTFIELD("Appraisal No.");
          NoSeriesMngt.InitSeries(HRSetup."Appraisal No.",xRec."No. Series",0D,"Entry No.","No. Series");
        END;
    end;

    var
        EmployeeList: Record "5200";
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        Appraise: Record "33020361";
        Total: Decimal;
        ApprisalTypeG: Option " ",Self,Manager,"Manager 360";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        WITH Appraise DO BEGIN
          Appraise := Rec;
          HRSetup.GET;
          HRSetup.TESTFIELD("Appraisal No.");
          IF NoSeriesMngt.SelectSeries(HRSetup."Appraisal No.",xRec."No. Series","No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Appraisal No.");
            NoSeriesMngt.SetSeries("Entry No.");
            Rec := Appraise;
            EXIT(TRUE);
          END;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateApprisalFromAsPerDesignation(DepCode: Code[20];No_: Code[20];XNo_: Code[20];AppType: Option " ",Self,Manager,"Manager 360")
    var
        DepartmentQuestion: Record "33019825";
        ApprisalSubfrom: Record "33019826";
    begin
        IF DepCode = '' THEN BEGIN
         ApprisalSubfrom.RESET;
         ApprisalSubfrom.SETRANGE("No.",No_);
         ApprisalSubfrom.SETRANGE(Posted,FALSE);
         ApprisalSubfrom.SETRANGE("Appraisal Type",AppType);
         ApprisalSubfrom.SETFILTER("Marks Obtained",'');
         ApprisalSubfrom.DELETEALL;
        END;

        IF XNo_ <> DepCode THEN BEGIN
         ApprisalSubfrom.RESET;
         ApprisalSubfrom.SETRANGE("No.",No_);
          ApprisalSubfrom.SETRANGE(Posted,FALSE);
          ApprisalSubfrom.SETRANGE("Appraisal Type",AppType);
           ApprisalSubfrom.SETFILTER("Marks Obtained",'');
         ApprisalSubfrom.DELETEALL;
        END;

        DepartmentQuestion.RESET;
        IF AppType = AppType::Manager THEN
          DepartmentQuestion.SETRANGE("Department Code",DepCode);
        DepartmentQuestion.SETRANGE("Apprisal Type",AppType);
        IF DepartmentQuestion.FINDSET THEN REPEAT
          ApprisalSubfrom.RESET;
          ApprisalSubfrom.SETRANGE("No.",No_);
          ApprisalSubfrom.SETRANGE("Question Code",DepartmentQuestion."Question Code");
          IF NOT ApprisalSubfrom.FINDFIRST THEN BEGIN
            ApprisalSubfrom.INIT;
            ApprisalSubfrom."No." := No_;
            ApprisalSubfrom."Question Code" := DepartmentQuestion."Question Code";
            ApprisalSubfrom.Department := DepCode;
            ApprisalSubfrom.Questions := DepartmentQuestion.Questions;
            ApprisalSubfrom."Total Marks" := DepartmentQuestion."Total Marks";
            ApprisalSubfrom."Appraisal Type" := AppType;
            ApprisalSubfrom.INSERT;
          END;
          UNTIL DepartmentQuestion.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SetApprisalType(AppType: Option " ",Self,Manager,"Manager 360")
    begin
        ApprisalTypeG := AppType;
    end;

    [Scope('Internal')]
    procedure UpdateApprisalFromAsPerDesignation2(DepCode: Code[20];No_: Code[20];XNo_: Code[20];AppType: Option " ",Self,Manager,"Manager 360")
    var
        DepartmentQuestion: Record "33019825";
        ApprisalSubfrom: Record "33019826";
    begin
        IF DepCode = '' THEN BEGIN
         ApprisalSubfrom.RESET;
         ApprisalSubfrom.SETRANGE("No.",No_);
         ApprisalSubfrom.SETRANGE(Posted,FALSE);
         ApprisalSubfrom.SETRANGE("Appraisal Type",AppType);
         ApprisalSubfrom.SETFILTER("Marks Obtained",'');
         ApprisalSubfrom.DELETEALL;
        END;

        IF XNo_ <> DepCode THEN BEGIN
         ApprisalSubfrom.RESET;
         ApprisalSubfrom.SETRANGE("No.",No_);
          ApprisalSubfrom.SETRANGE(Posted,FALSE);
          ApprisalSubfrom.SETRANGE("Appraisal Type",AppType);
           ApprisalSubfrom.SETFILTER("Marks Obtained",'');
         ApprisalSubfrom.DELETEALL;
        END;

        DepartmentQuestion.RESET;
        //IF AppType = AppType::Manager THEN
         DepartmentQuestion.SETRANGE("Department Code",DepCode);
        DepartmentQuestion.SETRANGE("Apprisal Type",AppType);
        IF DepartmentQuestion.FINDSET THEN REPEAT
          ApprisalSubfrom.RESET;
          ApprisalSubfrom.SETRANGE("No.",No_);
          ApprisalSubfrom.SETRANGE("Question Code",DepartmentQuestion."Question Code");
          IF NOT ApprisalSubfrom.FINDFIRST THEN BEGIN
            ApprisalSubfrom.INIT;
            ApprisalSubfrom."No." := No_;
            ApprisalSubfrom."Question Code" := DepartmentQuestion."Question Code";
            ApprisalSubfrom.Department := DepCode;
            ApprisalSubfrom.Questions := DepartmentQuestion.Questions;
            ApprisalSubfrom."Total Marks" := DepartmentQuestion."Total Marks";
            ApprisalSubfrom."Appraisal Type" := AppType;
            ApprisalSubfrom.INSERT;
          END;
          UNTIL DepartmentQuestion.NEXT = 0;
    end;
}

