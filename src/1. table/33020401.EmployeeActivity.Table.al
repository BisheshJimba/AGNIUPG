table 33020401 "Employee Activity"
{

    fields
    {
        field(1; "Activity No."; Code[50])
        {

            trigger OnValidate()
            begin
                IF "Activity No." <> xRec."Activity No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."EmpActivity No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Effective Date"; Date)
        {
        }
        field(3; "From Branch Code"; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Code = FIELD(From Branch Code),
                                                          Type=CONST(Branch));

            trigger OnValidate()
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(DimensionValue.Code, "From Branch Code");
                IF DimensionValue.FINDFIRST THEN BEGIN
                    "From Branch" := DimensionValue.Description;
                END;
            end;
        }
        field(4; "From Branch"; Text[100])
        {
            CalcFormula = Lookup("Location Master".Description WHERE(Code = FIELD(From Branch Code)));
            FieldClass = FlowField;
        }
        field(5; "To Branch Code"; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Code = FIELD(To Branch Code),
                                                          Type=CONST(Branch));

            trigger OnValidate()
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(DimensionValue.Code, "To Branch Code");
                IF DimensionValue.FINDFIRST THEN BEGIN
                    "To Branch" := DimensionValue.Description;
                END;
            end;
        }
        field(6; "To Branch"; Text[100])
        {
        }
        field(7; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.SETRANGE(EmpRec."No.", "Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    //EmpRec.CALCFIELDS(Manager);
                    "Employee Name" := EmpRec."Full Name";
                    Designation := EmpRec."Job Title";
                    "From Branch Code" := EmpRec."Branch Code";
                    "From Branch" := EmpRec."Branch Name";
                    "From Job Title Code" := EmpRec."Job Title code";
                    "From Job Title" := EmpRec."Job Title";
                    "From Department Code" := EmpRec."Department Code";
                    "From Department" := EmpRec."Department Name";
                    "From Grade" := EmpRec."Grade Code";
                    "From Manager ID" := EmpRec."Manager ID";
                    "From Manager Name" := EmpRec.Manager;
                    "To Branch Code" := EmpRec."Branch Code";
                    "To Branch" := EmpRec."Branch Name";
                    "To Job Title Code" := EmpRec."Job Title code";
                    "To Job Title" := EmpRec."Job Title";
                    "To Department Code" := EmpRec."Department Code";
                    "To Department" := EmpRec."Department Name";
                    "To Grade" := EmpRec."Grade Code";
                    "To Manager ID" := EmpRec."Manager ID";
                    "To Manager Name" := EmpRec.Manager;
                    "Basic Pay" := EmpRec."Basic Pay";
                    "Dearness Allowance" := EmpRec."Dearness Allowance";
                    "Other Allowance" := EmpRec."Other Allowance";
                    Total := EmpRec.Total;
                END;
            end;
        }
        field(8; "Employee Name"; Text[90])
        {
        }
        field(9; Designation; Text[100])
        {
        }
        field(10; Level; Text[30])
        {
        }
        field(11; "No. Series"; Code[10])
        {
        }
        field(12; Posted; Boolean)
        {
        }
        field(13; "From Job Title Code"; Code[20])
        {
            TableRelation = "Job Title".Code;

            trigger OnValidate()
            begin
                JobTitle.RESET;
                JobTitle.SETRANGE(Code, "From Job Title Code");
                IF JobTitle.FINDFIRST THEN BEGIN
                    "From Job Title" := JobTitle.Description;
                END;
            end;
        }
        field(14; "From Job Title"; Text[100])
        {
        }
        field(15; "To Job Title Code"; Code[20])
        {
            TableRelation = "Job Title".Code;

            trigger OnValidate()
            begin
                JobTitle.RESET;
                JobTitle.SETRANGE(Code, "To Job Title Code");
                IF JobTitle.FINDFIRST THEN BEGIN
                    "To Job Title" := JobTitle.Description;
                END;
            end;
        }
        field(16; "To Job Title"; Text[100])
        {
        }
        field(17; "From Department Code"; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Code = FIELD(From Department Code),
                                                          Type=CONST(Department));

            trigger OnValidate()
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "From Department Code");
                IF DimensionValue.FINDFIRST THEN BEGIN
                    "From Department" := DimensionValue.Description;
                END;
            end;
        }
        field(18; "From Department"; Text[100])
        {
        }
        field(19; "To Department Code"; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Code = FIELD(To Department Code),
                                                          Type=CONST(Department));

            trigger OnValidate()
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "To Department Code");
                IF DimensionValue.FINDFIRST THEN BEGIN
                    "To Department" := DimensionValue.Description;
                END;
            end;
        }
        field(20; "To Department"; Text[100])
        {
        }
        field(21; "From Grade"; Code[10])
        {
            TableRelation = Grades."Grade Code";
        }
        field(22; "To Grade"; Code[10])
        {
            TableRelation = Grades."Grade Code";
        }
        field(25; Activity; Option)
        {
            Description = ' ,Confirmed,Contract,Left,Permanent Transfer,Probation,Probation Extension,Promotion,Reporting Authority Change,Retired,Suspension,Temporary Transfer,Terminated,Trf Sister Concern,Upgradation';
            FieldClass = Normal;
            OptionCaption = ' ,Confirmed,Contract,Left,Permanent Transfer,Probation,Probation Extension,Promotion,Reporting Authority Change,Retired,Suspension,Temporary Transfer,Terminated,Trainee,Trf Sister Concern,Upgradation';
            OptionMembers = " ",Confirmed,Contract,Left,"Permanent Transfer",Probation,"Probation Extension",Promotion,"Reporting Authority Change",Retired,Suspension,"Temporary Transfer",Terminated,"Trf Sister Concern",Upgradation;
        }
        field(26; "From Manager Name"; Text[90])
        {
        }
        field(27; "To Manager Name"; Text[90])
        {
        }
        field(28; "Posted Date"; Date)
        {
        }
        field(29; "Posted By"; Code[50])
        {
        }
        field(30; Remark; Text[150])
        {
        }
        field(33; "Line No."; Integer)
        {
        }
        field(34; Comment; Text[80])
        {
        }
        field(35; "Basic Pay"; Decimal)
        {

            trigger OnValidate()
            begin
                Total := "Basic Pay" + "Dearness Allowance" + "Other Allowance";
            end;
        }
        field(36; "Dearness Allowance"; Decimal)
        {

            trigger OnValidate()
            begin
                Total := "Basic Pay" + "Dearness Allowance" + "Other Allowance";
            end;
        }
        field(37; "Other Allowance"; Decimal)
        {

            trigger OnValidate()
            begin
                Total := "Basic Pay" + "Dearness Allowance" + "Other Allowance";
            end;
        }
        field(38; Total; Decimal)
        {
        }
        field(39; "PF Percent"; Decimal)
        {
        }
        field(40; "From Manager ID"; Code[50])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "From Manager ID");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "From Manager Name" := EmpRec."Full Name";
                END ELSE
                    "From Manager Name" := '';
            end;
        }
        field(41; "To Manager ID"; Code[50])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "To Manager ID");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "To Manager Name" := EmpRec."Full Name";
                END ELSE
                    "To Manager Name" := '';
            end;
        }
    }

    keys
    {
        key(Key1; "Activity No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee Code", "Effective Date")
        {
        }
        key(Key3; "Employee Code", Activity, "To Grade", "Effective Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Activity No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."EmpActivity No.");
            NoSeriesMngt.InitSeries(HRSetup."EmpActivity No.", xRec."No. Series", 0D, "Activity No.", "No. Series");
        END;
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        EmpActivityRec: Record "33020401";
        EmpRec: Record "5200";
        DimensionValue: Record "33020337";
        JobTitle: Record "33020325";
        MasterOfManagerRec: Record "33020407";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        EmpActivityRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."EmpActivity No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."EmpActivity No.", xRec."No. Series", EmpActivityRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."EmpActivity No.");
            NoSeriesMngt.SetSeries(EmpActivityRec."Activity No.");
            Rec := EmpActivityRec;
            EXIT(TRUE);
        END;
    end;
}

