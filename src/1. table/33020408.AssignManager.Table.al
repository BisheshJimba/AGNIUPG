table 33020408 "Assign Manager"
{

    fields
    {
        field(1; "Assign No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Assign No." <> xRec."Assign No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Assign No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Employee Code"; Code[10])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(3; "Employee Name"; Text[90])
        {
        }
        field(4; "Department Code"; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE(Dimension Code=CONST(COST-REV),
                                                          Dimension Value Type=CONST(Standard));

            trigger OnValidate()
            begin
                DimensionValueRec.RESET;
                DimensionValueRec.SETRANGE(Code, "Department Code");
                IF DimensionValueRec.FINDFIRST THEN BEGIN
                    "Department Name" := DimensionValueRec.Name;
                END;
            end;
        }
        field(5; "Department Name"; Text[50])
        {
        }
        field(6; Designation; Option)
        {
            Description = ' ,HOD,Reporting 1,Reporting 2,Reporting 3,Reporting 4,Reporting 5,Reporting 6,Reporting 7,Reporting 8,Reporting 9,Reporting 10,VP,GM,CEO,EC,Reporting 11,Reporting 12,Reporting 13,Reporting 14,Reporting 15';
            OptionCaption = ' ,HOD,Reporting 1,Reporting 2,Reporting 3,Reporting 4,Reporting 5,Reporting 6,Reporting 7,Reporting 8,Reporting 9,Reporting 10,VP,GM,CEO,EC,Reporting 11,Reporting 12,Reporting 13,Reporting 14,Reporting 15';
            OptionMembers = " ",HOD,"Reporting 1","Reporting 2","Reporting 3","Reporting 4","Reporting 5","Reporting 6","Reporting 7","Reporting 8","Reporting 9","Reporting 10",VP,GM,CEO,EC,"Reporting 11","Reporting 12","Reporting 13","Reporting 14","Reporting 15";
        }
        field(7; "Assignment Posted"; Boolean)
        {
        }
        field(8; "Assignment Date"; Date)
        {
        }
        field(9; "No. Series"; Code[20])
        {
        }
        field(10; "Assignment Posted By"; Code[20])
        {
        }
        field(11; "Previous Manager Code"; Code[20])
        {
        }
        field(12; "Previous Manager"; Text[90])
        {
        }
    }

    keys
    {
        key(Key1; "Assign No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Assign No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Assign No.");
            NoSeriesMngt.InitSeries(HRSetup."Assign No.", xRec."No. Series", 0D, "Assign No.", "No. Series");
        END;
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        AssignManagerRec: Record "33020408";
        EmpRec: Record "5200";
        DimensionValueRec: Record "349";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        AssignManagerRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Assign No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Assign No.", xRec."No. Series", AssignManagerRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Assign No.");
            NoSeriesMngt.SetSeries(AssignManagerRec."Assign No.");
            Rec := AssignManagerRec;
            EXIT(TRUE);
        END;
    end;
}

