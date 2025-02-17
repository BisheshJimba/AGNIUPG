tableextension 50506 tableextension50506 extends "Finance Cue"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Overdue Sales Documents"(Field 2)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Purchase Documents Due Today"(Field 3)".


        //Unsupported feature: Property Modification (CalcFormula) on ""POs Pending Approval"(Field 4)".


        //Unsupported feature: Property Modification (CalcFormula) on ""SOs Pending Approval"(Field 5)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Approved Sales Orders"(Field 6)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Approved Purchase Orders"(Field 7)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Overdue Purchase Documents"(Field 16)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Purchase Discounts Next Week"(Field 17)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Purch. Invoices Due Next Week"(Field 18)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Requests to Approve"(Field 26)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Requests Sent for Approval"(Field 27)".

        field(50000; "Debit Note"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE(Document Type=CONST(Invoice),
                                                      Debit Note=CONST(Yes),
                                                      Document Profile=FILTER(Service|Spare Parts Trade|Vehicles Trade),
                                                      Responsibility Center=FIELD(Responsibility Center)));
            FieldClass = FlowField;
        }
        field(50001;"Finished Service Jobs";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=CONST(Invoice),
                                                      Debit Note=CONST(No),
                                                      Document Profile=FILTER(Service),
                                                      Responsibility Center=FIELD(Responsibility Center)));
            FieldClass = FlowField;
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(33020235;"Responsibility Center";Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Responsibility Center";
        }
    }
}

