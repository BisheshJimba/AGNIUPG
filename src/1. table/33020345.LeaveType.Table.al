table 33020345 "Leave Type"
{

    fields
    {
        field(1; "Leave Type Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Maximum Allowable Limit"; Decimal)
        {
        }
        field(4; "Carry Forward"; Boolean)
        {
        }
        field(5; "Total Absence (Base)"; Decimal)
        {
            CalcFormula = Sum("Leave Register"."Used Days" WHERE(Leave Type Code=FIELD(Leave Type Code),
                                                                  Employee No.=FIELD(Employee No. Filter),
                                                                  Leave Start Date=FIELD(Date Filter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Employee No. Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Employee.No.;
        }
        field(7;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(8;"Days Earned Per Year";Decimal)
        {
        }
        field(9;"Maximum Earnable Limit";Decimal)
        {
        }
        field(10;Encashable;Boolean)
        {
        }
        field(11;"Maximum Encashable Limit";Integer)
        {
        }
        field(12;"Full - Paid";Boolean)
        {
        }
        field(13;"Times Per Service Period";Integer)
        {
        }
        field(14;"CheckList Reqd.";Boolean)
        {
        }
        field(15;"Higher Authority Approval Reqd";Boolean)
        {
        }
        field(16;"Earnable Per Year";Boolean)
        {
        }
        field(17;"Earned Per Month";Boolean)
        {
        }
        field(18;"Min. Balance Days for Encash";Decimal)
        {
        }
        field(19;OnlyForFemale;Boolean)
        {
        }
        field(20;"Half - Paid";Boolean)
        {
        }
        field(21;"Min. Leave Per Day";Decimal)
        {
        }
        field(22;"Pay Type";Option)
        {
            OptionCaption = ' ,Half Paid,Paid,Unpaid';
            OptionMembers = " ","Half Paid",Paid,Unpaid;
        }
    }

    keys
    {
        key(Key1;"Leave Type Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

