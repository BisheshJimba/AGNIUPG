tableextension 50313 tableextension50313 extends "FA Setup"
{
    fields
    {
        field(11; "Employee No."; Code[20])
        {
            TableRelation = Employee.No.;
        }
        field(12; Days; DateFormula)
        {
        }
    }
}

