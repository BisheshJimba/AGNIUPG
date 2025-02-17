tableextension 50410 tableextension50410 extends "Purchase Price"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5700)".

        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006701; "Last Modifoed By"; Text[100])
        {
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Item No.,Vendor No.,Starting Date,Currency Code,Variant Code,Unit of Measure Code,Minimum Quantity"(Key)".

        key(Key1; "Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code")
        {
            Clustered = true;
        }
    }


    //Unsupported feature: Code Insertion on "OnModify".

    //trigger OnModify()
    //begin
    /*
    "Last Modifoed By" := USERID;
    */
    //end;
}

