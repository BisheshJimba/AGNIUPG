table 33020346 "Leave ApprovedOrDisapproved"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmployeeRec.RESET;
                EmployeeRec.SETRANGE("No.", "Employee No.");
                IF EmployeeRec.FIND('-') THEN BEGIN
                    "First Name" := EmployeeRec."First Name";
                    "Middle Name" := EmployeeRec."Middle Name";
                    "Last Name" := EmployeeRec."Last Name";
                END;
            end;
        }
        field(3; "First Name"; Text[30])
        {
        }
        field(4; "Middle Name"; Text[30])
        {
        }
        field(5; "Last Name"; Text[30])
        {
        }
        field(6; "Leave Type Code"; Code[20])
        {
            TableRelation = "Leave Type"."Leave Type Code";

            trigger OnValidate()
            begin
                CALCFIELDS("Leave Description");
            end;
        }
        field(7; "Leave Description"; Text[100])
        {
            CalcFormula = Lookup("Leave Type".Description WHERE(Leave Type Code=FIELD(Leave Type Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Requested Leave Start Date";Date)
        {
        }
        field(9;"Requested Leave End Date";Date)
        {
        }
        field(10;"Granted Leave Start Date";Date)
        {
        }
        field(11;"Granted Leave End Date";Date)
        {
        }
        field(12;Approved;Boolean)
        {
            Editable = false;
        }
        field(13;Partial;Boolean)
        {
        }
        field(14;"Approved By";Text[30])
        {
            Editable = false;
        }
        field(15;"Approved Date";Date)
        {
            Editable = false;
        }
        field(16;"Approval Remarks";Text[250])
        {
        }
        field(17;"Rejected By";Text[30])
        {
        }
        field(18;"Reject Date";Date)
        {
        }
        field(19;"Rejection Remarks";Text[250])
        {
        }
        field(20;"User ID";Text[30])
        {
        }
        field(21;Disapproved;Boolean)
        {
        }
        field(22;"Fiscal Year";Code[10])
        {
        }
        field(23;"Pay Type";Option)
        {
            Description = ' ,Half Paid,Paid,Unpaid';
            OptionCaption = ' ,Half Paid,Paid,Unpaid';
            OptionMembers = " ","Half Paid",Paid,Unpaid;
        }
        field(24;"Full Name";Text[90])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.","Employee No.")
        {
            Clustered = true;
        }
        key(Key2;"Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EmployeeRec: Record "5200";
}

