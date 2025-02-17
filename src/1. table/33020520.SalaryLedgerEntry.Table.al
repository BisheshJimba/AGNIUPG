table 33020520 "Salary Ledger Entry"
{
    DrillDownPageID = 33020527;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; "Salary From"; Date)
        {
        }
        field(4; "Salary To"; Date)
        {
        }
        field(5; "Fiscal Year From"; Date)
        {
        }
        field(6; "Fiscal Year To"; Date)
        {
        }
        field(7; "Basic Salary"; Decimal)
        {
        }
        field(8; "Total Benefits"; Decimal)
        {
            Description = 'Excluding Basic Salary';
        }
        field(9; "Total Deduction"; Decimal)
        {
        }
        field(10; "Tax Paid"; Decimal)
        {
        }
        field(11; "Tax Credit"; Decimal)
        {
        }
        field(12; "Total Employer Contribution"; Decimal)
        {
        }
        field(13; "Posting Type"; Option)
        {
            OptionCaption = ' ,Settlement';
            OptionMembers = " ",Settlement;
        }
        field(14; "Creation Date"; Date)
        {
        }
        field(15; CIT; Decimal)
        {
        }
        field(16; "Tax Paid on First Account"; Decimal)
        {
        }
        field(17; "Tax Paid on Second Account"; Decimal)
        {
        }
        field(18; "Last Slab (%)"; Decimal)
        {
        }
        field(19; "Provident Fund"; Decimal)
        {
            Description = 'total employer and employee';
        }
        field(20; "Remaining Amount to Cross Slab"; Decimal)
        {
            Description = 'Extra Income needed to change tax slab';
        }
        field(23; "Irregular Process"; Boolean)
        {
        }
        field(50; "Basic Cummulation"; Decimal)
        {
            CalcFormula = Sum("Salary Ledger Entry"."Basic Salary" WHERE(Employee Code=FIELD(Employee Filter),
                                                                          Fiscal Year From=FIELD(Fiscal Year DateFilter)));
            FieldClass = FlowField;
        }
        field(55;"Tax Cummulation";Decimal)
        {
            CalcFormula = Sum("Salary Ledger Entry"."Tax Paid" WHERE (Employee Code=FIELD(Employee Filter),
                                                                      Fiscal Year From=FIELD(Fiscal Year DateFilter)));
            FieldClass = FlowField;
        }
        field(59;"Benefit Cummulation";Decimal)
        {
            CalcFormula = Sum("Salary Ledger Entry"."Total Benefits" WHERE (Employee Code=FIELD(Employee Filter),
                                                                            Fiscal Year From=FIELD(Fiscal Year DateFilter)));
            FieldClass = FlowField;
        }
        field(60;"Deduction Cummulation";Decimal)
        {
            CalcFormula = Sum("Salary Ledger Entry"."Total Deduction" WHERE (Employee Code=FIELD(Employee Filter),
                                                                             Fiscal Year From=FIELD(Fiscal Year DateFilter)));
            FieldClass = FlowField;
        }
        field(61;"Emp. Contribution Cummulation";Decimal)
        {
            CalcFormula = Sum("Salary Ledger Entry"."Total Employer Contribution" WHERE (Employee Code=FIELD(Employee Filter),
                                                                                         Fiscal Year From=FIELD(Fiscal Year DateFilter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(62;"CIT Cummulation";Decimal)
        {
            CalcFormula = Sum("Salary Ledger Entry".CIT WHERE (Employee Code=FIELD(Employee Filter),
                                                               Fiscal Year From=FIELD(Fiscal Year DateFilter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"Fiscal Year DateFilter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(101;"Employee Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(102;Reversed;Boolean)
        {
        }
        field(103;"Reversed Entry No.";Integer)
        {
        }
        field(105;"Source No.";Code[20])
        {
            Description = 'Posted Document No. from Posted Salary Header';
        }
        field(106;"Gratuity Amount";Decimal)
        {
        }
        field(107;"Gratuity TDS Payable";Decimal)
        {
        }
        field(108;"Net Gratuity";Decimal)
        {
        }
        field(109;"SSF(1.67%) Amount";Decimal)
        {
        }
        field(110;"Aryan Reversed";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Employee Code","Fiscal Year From","Fiscal Year To","Irregular Process")
        {
            SumIndexFields = "Basic Salary","Total Benefits","Total Deduction","Tax Paid","Total Employer Contribution",CIT,"Tax Paid on First Account","Tax Paid on Second Account";
        }
        key(Key3;"Employee Code","Salary From","Salary To")
        {
        }
    }

    fieldgroups
    {
    }
}

