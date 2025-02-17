table 33019915 "Document Approval Entry"
{
    Caption = 'Document Approval Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Table ID"; Integer)
        {
            TableRelation = "Table Information"."Table No.";
        }
        field(3; "Document Type"; Option)
        {
            OptionCaption = ' ,Fuel Issue,Courier,LC,Vehicle Insurance,Vehicle Custom Clearance,General Procurement,HR,Payroll';
            OptionMembers = " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll;
        }
        field(4; "Document No."; Code[20])
        {
        }
        field(5; "Sequence No."; Integer)
        {
        }
        field(6; "Sender ID"; Code[50])
        {
            TableRelation = Table2000000002.Field1;
        }
        field(7; "Approver ID"; Code[50])
        {
            TableRelation = Table2000000002.Field1;
        }
        field(8; Status; Option)
        {
            OptionCaption = 'Open,Canceled,Rejected,Approved';
            OptionMembers = Open,Canceled,Rejected,Approved;
        }
        field(9; "Date Time Sent for Approval"; DateTime)
        {
        }
        field(10; "Last Modified By"; Code[50])
        {
        }
        field(11; "Last Date Time Modified"; DateTime)
        {
        }
        field(12; "Due Date"; Date)
        {
        }
        field(13; "Entry Type"; Option)
        {
            OptionCaption = ' ,Coupon,Stock,Cash,CVD,PCD,Requisition,Summary';
            OptionMembers = " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary;
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
}

