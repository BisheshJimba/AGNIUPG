tableextension 50232 tableextension50232 extends Campaign
{
    // 03.07.2015 EB.P30
    //   Specified Table DrillDownPageID
    DrillDownPageID = 5087;
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 6)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Target Contacts Contacted"(Field 12)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Contacts Responded"(Field 13)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Duration (Min.)"(Field 14)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cost (LCY)"(Field 16)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Opportunities"(Field 17)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Estimated Value (LCY)"(Field 18)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Calcd. Current Value (LCY)"(Field 19)".

        modify("Contact Company Filter")
        {
            TableRelation = Contact WHERE(Type = CONST(" "));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Opportunity Entry Exists"(Field 38)".


        //Unsupported feature: Property Modification (CalcFormula) on ""To-do Entry Exists"(Field 39)".

        field(25006010; "Campaign Applies to All"; Boolean)
        {
            Caption = 'Campaign Applies to All';
        }
        field(25006020; "Activated (Sales)"; Boolean)
        {
            Caption = 'Activated (Sales)';
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Activated (Sales)")
        {
        }
    }
}

