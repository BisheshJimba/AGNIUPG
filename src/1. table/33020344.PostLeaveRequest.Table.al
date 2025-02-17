table 33020344 "Post Leave Request"
{

    fields
    {
        field(1; "Manager ID"; Code[20])
        {
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
                    "Full Name" := EmployeeRec."Full Name";
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
        field(8;"Leave Start Date";Date)
        {
        }
        field(9;"Leave End Date";Date)
        {
        }
        field(10;"Leave Start Time";Time)
        {
        }
        field(11;"Leave End Time";Time)
        {
        }
        field(12;Remarks;Text[250])
        {
        }
        field(13;Approved;Boolean)
        {

            trigger OnValidate()
            begin
                IF NOT (Approved = Approved::"0") THEN
                  "Approval Date" := TODAY;
            end;
        }
        field(14;"Approval Comment";Text[250])
        {
        }
        field(15;"Approval Date";Date)
        {
        }
        field(16;Posted;Boolean)
        {
        }
        field(17;"Posted Date";Date)
        {
        }
        field(18;"Work Shift Code";Code[10])
        {
            TableRelation = "Work Shift".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Work Shift Description");
            end;
        }
        field(19;"Entry No.";Integer)
        {
            AutoIncrement = true;
        }
        field(20;"Requested Date";Date)
        {
        }
        field(21;Rejected;Boolean)
        {

            trigger OnValidate()
            begin
                IF NOT (Rejected = Rejected::"0") THEN
                  "Reject Date" := TODAY;
            end;
        }
        field(22;"Reject Date";Date)
        {
        }
        field(23;"Rejection Remarks";Text[250])
        {
        }
        field(24;"Granted Start Date";Date)
        {
        }
        field(25;"Granted End Date";Date)
        {
        }
        field(26;"Work Shift Description";Text[100])
        {
            CalcFormula = Lookup("Work Shift".Description WHERE (Code=FIELD(Work Shift Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27;"Leave Request No.";Code[20])
        {
        }
        field(28;"Job Title Code";Code[20])
        {
            TableRelation = "Job Title".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Job Description");
            end;
        }
        field(29;"Job Description";Text[100])
        {
            CalcFormula = Lookup("Job Title".Description WHERE (Code=FIELD(Job Title Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(30;"Request Time";Time)
        {
        }
        field(31;"Fiscal Year";Code[10])
        {
        }
        field(32;"No. of Days";Decimal)
        {
        }
        field(33;"Full Name";Text[100])
        {
        }
        field(34;"Pay Type";Option)
        {
            Description = ' ,Half Paid,Paid,Unpaid';
            OptionCaption = ' ,Half Paid,Paid,Unpaid';
            OptionMembers = " ","Half Paid",Paid,Unpaid;
        }
        field(35;"Requeste Date (BS)";Text[30])
        {
        }
        field(36;"Manager Name";Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE (No.=FIELD(Manager ID)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Manager ID","Employee No.","Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Employee No.","Leave Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EmployeeRec: Record "5200";
}

