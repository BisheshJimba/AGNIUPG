table 33020329 "Application Interview Details"
{

    fields
    {
        field(1; "Application No."; Code[20])
        {
            TableRelation = Application.No.;
        }
        field(2; "Rating 1"; Option)
        {
            Caption = 'Rating 1';
            Description = 'Interviewer One';
            NotBlank = true;
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;

            trigger OnValidate()
            begin
                /*Application.RESET;
                Application.SETRANGE("No.","Application No.");
                IF Application.FIND('-') THEN BEGIN
                  EVALUATE(Application.Status,'Interviewed');
                  Application.Interviewed := TRUE;
                  Application.VALIDATE("Interviewed Date",TODAY);
                  Application.MODIFY;
                END;
                */

            end;
        }
        field(3; "Communication 1"; Option)
        {
            Caption = 'Communication';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(4; "Knowledge 1"; Option)
        {
            Caption = 'Knowledge 1';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(5; "Attitude 1"; Option)
        {
            Caption = 'Attitude 1';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(6; "Remarks 1"; Text[250])
        {
            Caption = 'Remarks 1';
        }
        field(7; "Interview Date AD 1"; Date)
        {
            Caption = 'Interview Date AD 1';

            trigger OnValidate()
            begin
                "Add. Interview Date AD 1" := STPLSysMgmt.getNepaliDate("Interview Date AD 1");
            end;
        }
        field(8; "Add. Interview Date AD 1"; Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020329, 8);
            Caption = 'Add. Interview Date AD 1';

            trigger OnValidate()
            begin
                "Interview Date AD 1" := STPLSysMgmt.getEngDate("Add. Interview Date AD 1");
            end;
        }
        field(9; "Int. Duration 1"; Decimal)
        {
            Caption = 'Int. Duration 1';
        }
        field(10; "Initiative 1"; Option)
        {
            Caption = 'Initiative';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(11; "Interest CP 1"; Option)
        {
            Caption = 'Interest Company/Position';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(12; "Interviewed By 1"; Code[20])
        {
            Caption = 'Interviewed By';
            TableRelation = Employee.No. WHERE(Status = CONST(" "));

            trigger OnValidate()
            begin
                //CALCFIELDS("Interviewed By 1 Name");
            end;
        }
        field(13; "Interviewed By 1 Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."First Name" WHERE(No.=FIELD(Interviewed By 1)));
            Caption = 'Interviewed By 1 Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14;"Rating 2";Option)
        {
            Caption = 'Rating';
            Description = 'Interviewer Two';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(15;"Communication 2";Option)
        {
            Caption = 'Communication';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(16;"Knowledge 2";Option)
        {
            Caption = 'Knowledge';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(17;"Attitude 2";Option)
        {
            Caption = 'Attitude';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(18;"Remarks 2";Text[250])
        {
            Caption = 'Remarks';
        }
        field(19;"Interview Date AD 2";Date)
        {
            Caption = 'Interview Date';

            trigger OnValidate()
            begin
                "Add. Interview Date AD 2" := STPLSysMgmt.getNepaliDate("Interview Date AD 2");
            end;
        }
        field(20;"Add. Interview Date AD 2";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020329,20);
            Caption = 'Add. Interview Date 2';

            trigger OnValidate()
            begin
                "Interview Date AD 2" := STPLSysMgmt.getEngDate("Add. Interview Date AD 2");
            end;
        }
        field(21;"Int. Duration 2";Decimal)
        {
            Caption = 'Interview Duration';
        }
        field(22;"Initiative 2";Option)
        {
            Caption = 'Initiative';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(23;"Interest CP 2";Option)
        {
            Caption = 'Interest Company/Position';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(24;"Interviewed By 2";Code[20])
        {
            Caption = 'Interviewed By';
            TableRelation = Employee.No. WHERE (Status=CONST(" "));

            trigger OnValidate()
            begin
                //CALCFIELDS("Interviewed By 2 Name");
            end;
        }
        field(25;"Interviewed By 2 Name";Text[30])
        {
            CalcFormula = Lookup(Employee."First Name" WHERE (No.=FIELD(Interviewed By 2)));
            Caption = 'Interviewed By 2 Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26;"Rating 3";Option)
        {
            Caption = 'Rating';
            Description = 'Interviewer Two';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(27;"Communication 3";Option)
        {
            Caption = 'Communication';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(28;"Knowledge 3";Option)
        {
            Caption = 'Knowledge';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(29;"Attitude 3";Option)
        {
            Caption = 'Attitude';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(30;"Remarks 3";Text[250])
        {
            Caption = 'Remarks';
        }
        field(31;"Interview Date AD 3";Date)
        {
            Caption = 'Interview Date';

            trigger OnValidate()
            begin
                "Add. Interview Date AD 3" := STPLSysMgmt.getNepaliDate("Interview Date AD 3");
            end;
        }
        field(32;"Add. Interview Date AD 3";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020329,32);
            Caption = 'Add. Interview Date 3';

            trigger OnValidate()
            begin
                "Interview Date AD 3" := STPLSysMgmt.getEngDate("Add. Interview Date AD 3");
            end;
        }
        field(33;"Int. Duration 3";Decimal)
        {
            Caption = 'Interview Duration';
        }
        field(34;"Initiative 3";Option)
        {
            Caption = 'Initiative';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(35;"Interest CP 3";Option)
        {
            Caption = 'Interest Company/Position';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(36;"Interviewed By 3";Code[20])
        {
            Caption = 'Interviewed By';
            TableRelation = Employee.No. WHERE (Status=CONST(" "));

            trigger OnValidate()
            begin
                //CALCFIELDS("Interviewed By 3 Name");
            end;
        }
        field(37;"Interviewed By 3 Name";Text[30])
        {
            CalcFormula = Lookup(Employee."First Name" WHERE (No.=FIELD(Interviewed By 3)));
            Caption = 'Interviewed By 3 Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(38;"Rating 4";Option)
        {
            Caption = 'Rating';
            Description = 'Interviewer Two';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(39;"Communication 4";Option)
        {
            Caption = 'Communication';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(40;"Knowledge 4";Option)
        {
            Caption = 'Knowledge';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(41;"Attitude 4";Option)
        {
            Caption = 'Attitude';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(42;Weakness;Text[250])
        {
        }
        field(43;"Interview Date AD 4";Date)
        {
            Caption = 'Approved Date';
            Description = 'Approved Date';

            trigger OnValidate()
            begin
                "Add. Interview Date AD 4" := STPLSysMgmt.getNepaliDate("Interview Date AD 4");
            end;
        }
        field(44;"Add. Interview Date AD 4";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020329,44);
            Caption = 'Add. Interview Date 4';
            Description = 'Add. Approved Date';

            trigger OnValidate()
            begin
                "Interview Date AD 4" := STPLSysMgmt.getEngDate("Add. Interview Date AD 4");
            end;
        }
        field(45;"Int. Duration 4";Decimal)
        {
            Caption = 'Interview Duration';
        }
        field(46;"Initiative 4";Option)
        {
            Caption = 'Initiative';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(47;"Interest CP 4";Option)
        {
            Caption = 'Interest Company/Position';
            OptionMembers = " ",Excellent,Good,Satisfactory,Fair,Poor;
        }
        field(48;"Approved By";Code[20])
        {
            TableRelation = Employee.No. WHERE (Status=CONST(" "));

            trigger OnValidate()
            begin
                //CALCFIELDS("Approved By Name");
            end;
        }
        field(49;"Approved By Name";Text[30])
        {
            CalcFormula = Lookup(Employee."First Name" WHERE (No.=FIELD(Approved By)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50;Status;Option)
        {
            OptionMembers = " ",Hold,Selected,Rejected,"Future Requirement";
        }
        field(51;Strength;Text[250])
        {
        }
        field(52;"Expected Salary 1";Decimal)
        {
            Caption = 'Expected Salary';
        }
        field(53;"Expected Salary 2";Decimal)
        {
            Caption = 'Expected Salary';
        }
        field(54;"Expected Salary 3";Decimal)
        {
            Caption = 'Expected Salary';
        }
        field(55;"Written Assessment Score";Decimal)
        {

            trigger OnValidate()
            begin
                IF ApplicationNew.GET("Application No.") THEN BEGIN
                  ApplicationNew."Written Marks" := "Written Assessment Score";
                  ApplicationNew.MODIFY;
                  END;
            end;
        }
        field(56;"Interview Score";Option)
        {
            OptionCaption = ' ,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = " ","1","2","3","4","5","6","7","8","9","10";

            trigger OnValidate()
            begin
                IF ApplicationNew.GET("Application No.") THEN BEGIN
                  ApplicationNew."Interview Marks" := "Interview Score";
                  ApplicationNew.MODIFY;
                  END;
            end;
        }
    }

    keys
    {
        key(Key1;"Application No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        STPLSysMgmt: Codeunit "50000";
        Application: Record "33020330";
        ApplicationNew: Record "33020382";
}

