tableextension 50110 tableextension50110 extends "Source Code Setup"
{
    fields
    {
        field(25006100; "Service Management EDMS"; Code[10])
        {
            Caption = 'Service Management EDMS';
            TableRelation = "Source Code";
        }
        field(25006110; "Service G/L WIP EDMS"; Code[10])
        {
        }
        field(25006670; "Item Replacement Journal"; Code[10])
        {
            Caption = 'Item Replacement Journal';
            TableRelation = "Source Code";
        }
        field(33019961; "Fuel Issue Entry"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(33019962; "Fuel Journal Line"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(33019963; "Courier Tracking"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(33020500; "Payroll Management"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(33020550; "Attendance Management"; Code[10])
        {
            TableRelation = "Source Code";
        }
    }
}

