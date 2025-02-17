table 33020403 "Trainee Records"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "First Name"; Text[50])
        {
        }
        field(3; "Ward No."; Text[30])
        {
        }
        field(4; "Phone No."; Text[30])
        {
        }
        field(5; Education; Text[30])
        {
        }
        field(6; "Start Date"; Date)
        {
        }
        field(7; "Complete Date"; Date)
        {

            trigger OnValidate()
            begin
                months := ROUND(("Complete Date" - "Start Date") / 30, 0.01);
                Durations := months;
            end;
        }
        field(8; Durations; Decimal)
        {
        }
        field(9; Designation; Text[50])
        {
        }
        field(10; "Direct Supervisor Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.SETRANGE(EmpRec."No.", "Direct Supervisor Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "Direct Supervisor" := EmpRec."Full Name";
                    "Supervisor Job Title" := EmpRec."Job Title";
                END;
            end;
        }
        field(11; "Direct Supervisor"; Text[50])
        {
        }
        field(12; "Department Code"; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DepartRec.SETRANGE(DepartRec.Code, "Department Code");
                IF DepartRec.FINDFIRST THEN BEGIN
                    Department := DepartRec.Description;
                END;
            end;
        }
        field(13; Department; Text[50])
        {
        }
        field(14; "Branch Code"; Code[10])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Branch));

            trigger OnValidate()
            begin
                DepartRec.SETRANGE(Code, "Branch Code");
                IF DepartRec.FINDFIRST THEN BEGIN
                    Branch := DepartRec.Description;
                END;
            end;
        }
        field(15; Remarks; Text[100])
        {
        }
        field(16; Posted; Boolean)
        {
        }
        field(17; "Posted Date"; Date)
        {
        }
        field(18; Branch; Text[30])
        {
        }
        field(19; "Posted By"; Code[20])
        {
        }
        field(20; "Job Title Code"; Code[20])
        {
            TableRelation = "Job Title".Code WHERE(Minimum Education=CONST(No));

            trigger OnValidate()
            begin
                JobRec.RESET;
                JobRec.SETRANGE(Code, "Job Title Code");
                IF JobRec.FINDFIRST THEN BEGIN
                    "Job Title" := JobRec.Description;
                END;
            end;
        }
        field(21; "Job Title"; Text[100])
        {
        }
        field(22; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(23; "Supervisor Job Title"; Text[100])
        {
        }
        field(24; "VDC/ NP"; Text[30])
        {
        }
        field(25; District; Text[30])
        {
        }
        field(26; "Middle Name"; Text[30])
        {
        }
        field(27; "Last Name"; Text[30])
        {
        }
        field(30; "Marrital Status"; Option)
        {
            Description = ' ,Single,Married';
            OptionCaption = ' ,Single,Married';
            OptionMembers = " ",Single,Married;
        }
        field(31; Company; Option)
        {
            Description = ' ,STPL,SENPL,SEMPL,SAPPL,SASPL';
            OptionCaption = ' ,STPL,SENPL,SEMPL,SAPPL,SASPL';
            OptionMembers = " ",STPL,SENPL,SEMPL,SAPPL,SASPL;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        EmpRec: Record "5200";
        DepartRec: Record "33020337";
        months: Decimal;
        JobRec: Record "33020325";
}

