table 33020402 "Intern Records"
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
        field(3; "College/ Institution Name"; Text[50])
        {
        }
        field(4; Education; Text[30])
        {
        }
        field(5; "Phone No."; Text[30])
        {
        }
        field(6; "Direct Supervisor Code"; Code[20])
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
        field(7; "Direct Supervisor"; Text[50])
        {
        }
        field(8; "Department Code"; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department),
                                                          Blocked = CONST(No));

            trigger OnValidate()
            begin
                DeptRec.SETRANGE(DeptRec.Code, "Department Code");
                IF DeptRec.FINDFIRST THEN BEGIN
                    "Department Name" := DeptRec.Description;
                END;
            end;
        }
        field(9; "Branch Code"; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Branch),
                                                          Blocked = CONST(No));

            trigger OnValidate()
            begin
                DeptRec.SETRANGE(Code, "Branch Code");
                IF DeptRec.FINDFIRST THEN BEGIN
                    "Branch Name" := DeptRec.Description;
                END;
            end;
        }
        field(10; "Start Date"; Date)
        {
        }
        field(11; "Complete Date"; Date)
        {

            trigger OnValidate()
            begin
                months := ROUND(("Complete Date" - "Start Date") / 30, 0.01);
                "Duration (Months)" := months;
            end;
        }
        field(12; "Duration (Months)"; Decimal)
        {
        }
        field(13; Attendance; Boolean)
        {
        }
        field(14; IDate; Date)
        {
        }
        field(15; "Report"; Boolean)
        {
        }
        field(16; "Experience Letter"; Boolean)
        {
        }
        field(17; Posted; Boolean)
        {
        }
        field(18; "Posted Date"; Date)
        {
        }
        field(19; "Department Name"; Text[100])
        {
        }
        field(20; "Branch Name"; Text[100])
        {
        }
        field(21; "Posted By"; Code[50])
        {
        }
        field(22; "Job Title Code"; Code[20])
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
        field(23; "Job Title"; Text[100])
        {
        }
        field(24; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(25; "Supervisor Job Title"; Text[100])
        {
        }
        field(26; "VDC/ NP"; Text[30])
        {
        }
        field(27; District; Text[30])
        {
        }
        field(28; "Middle Name"; Text[30])
        {
        }
        field(29; "Last Name"; Text[30])
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
        DeptRec: Record "33020337";
        months: Decimal;
        JobRec: Record "33020325";
}

