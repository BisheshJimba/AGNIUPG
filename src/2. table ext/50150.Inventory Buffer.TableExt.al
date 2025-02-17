tableextension 50150 tableextension50150 extends "Inventory Buffer"
{
    // 18.10.2007. EDMS P2
    //   * Added key "Location Code, Bin Code"
    // 
    // //EDMS
    //  * New field 25006379 "Vehicle Accounting Cycle No." (added to primary key)
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5400)".

        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
    }
    keys
    {
        key(Key1; "Location Code", "Bin Code")
        {
        }
    }
}

