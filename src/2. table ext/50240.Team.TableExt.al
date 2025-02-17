tableextension 50240 tableextension50240 extends Team
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Next To-do Date"(Field 3)".

        modify("Contact Company Filter")
        {
            TableRelation = Contact WHERE(Type = CONST(" "));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""To-do Entry Exists"(Field 13)".

        field(33020142; "Vehicle Division"; Option)
        {
            OptionCaption = ' ,CVD,PCD';
            OptionMembers = " ",CVD,PCD;
        }
    }
}

