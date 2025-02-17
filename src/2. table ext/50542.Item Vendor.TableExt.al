tableextension 50542 tableextension50542 extends "Item Vendor"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5700)".

        field(33019810; "Vendor Level"; Code[10])
        {
            TableRelation = "NCHL-NPI Entry"."Entry No.";
        }
    }
}

