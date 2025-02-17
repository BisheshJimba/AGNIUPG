tableextension 50132 tableextension50132 extends "Phys. Inventory Ledger Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade";
        }
        field(25006001; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = " ",Item,"Model Version";
        }
        field(25006002; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006003; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(25006004;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnLookup()
            var
                recItem: Record "27";
            begin
                recItem.SETCURRENTKEY("Item Type","Make Code","Model Code");
                recItem.SETRANGE("Item Type",recItem."Item Type"::"Model Version");
                recItem.SETRANGE("Make Code","Make Code");
                recItem.SETRANGE("Model Code","Model Code");
                IF PAGE.RUNMODAL(PAGE::"Item List",recItem) = ACTION::LookupOK THEN //30.10.2012 EDMS
                 BEGIN
                  VALIDATE("Model Version No.",recItem."No.");
                 END;
            end;
        }
        field(25006005;VIN;Code[20])
        {
            Caption = 'VIN';
            TableRelation = Vehicle;
        }
    }
}

