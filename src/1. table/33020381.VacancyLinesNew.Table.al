table 33020381 "Vacancy Lines New"
{

    fields
    {
        field(1; "Vacancy No"; Code[20])
        {
        }
        field(2; "Vacancy SubCode"; Code[20])
        {
        }
        field(3; "Position Code"; Code[10])
        {
            TableRelation = "Job Title".Code;

            trigger OnValidate()
            begin
                JobTitle.SETRANGE(Code, "Position Code");
                IF JobTitle.FIND('-') THEN
                    Position := JobTitle.Description;
            end;
        }
        field(4; Position; Text[50])
        {
        }
        field(5; "Dept Code"; Code[10])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                MasterRec.RESET;
                MasterRec.SETRANGE(Code, "Dept Code");
                IF MasterRec.FINDFIRST THEN BEGIN
                    "Department Name" := MasterRec.Description;
                END;
                IF MasterRec.COUNT = 0 THEN
                    "Department Name" := '';
            end;
        }
        field(6; "Department Name"; Text[50])
        {
        }
        field(7; "Branch Code"; Code[10])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Branch));

            trigger OnValidate()
            begin
                MasterRec.RESET;
                MasterRec.SETRANGE(Code, "Branch Code");
                IF MasterRec.FINDFIRST THEN BEGIN
                    "Branch Name" := MasterRec.Description;
                END;
                IF MasterRec.COUNT = 0 THEN
                    "Branch Name" := '';
            end;
        }
        field(8; "Branch Name"; Text[50])
        {
        }
        field(9; "No. of Opening"; Integer)
        {
        }
        field(10; "Min. Qualification"; Text[50])
        {
        }
        field(11; "Work Experience"; Text[50])
        {
        }
        field(12; EmployeeReqNo; Code[20])
        {
            TableRelation = "Emp Requisition Form".EmpReqNo WHERE(Posted Date=FILTER(<>''));
        }
        field(13;"Total Employed";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Vacancy No","Vacancy SubCode")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        JobTitle: Record "33020325";
        MasterRec: Record "33020337";
}

