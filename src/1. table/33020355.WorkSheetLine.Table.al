table 33020355 "Work Sheet Line"
{

    fields
    {
        field(1; "Employee ID"; Code[20])
        {
            TableRelation = "Work Sheet Header"."Employee ID";
        }
        field(2; Year; Integer)
        {
        }
        field(3; Month; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(4; Week; Integer)
        {
        }
        field(5; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(6; Day; Option)
        {
            OptionCaption = 'Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday';
            OptionMembers = Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday;
        }
        field(7; "Job Description"; Text[250])
        {
        }
        field(8; Client; Code[20])
        {
            TableRelation = Customer.No.;

            trigger OnValidate()
            begin
                CALCFIELDS("Client Name");
            end;
        }
        field(9; Project; Code[10])
        {
            TableRelation = Project.Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Project Name");
            end;
        }
        field(10; "Hours Worked"; Decimal)
        {
        }
        field(11; "Client Visit"; Boolean)
        {
        }
        field(12; Purpose; Text[250])
        {
        }
        field(13; "Hours Spended"; Decimal)
        {
        }
        field(14; "Client Name"; Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE(No.=FIELD(Client)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15;"Project Name";Text[100])
        {
            CalcFormula = Lookup(Project.Description WHERE (Code=FIELD(Project)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Employee ID",Year,Month,Week,"Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

