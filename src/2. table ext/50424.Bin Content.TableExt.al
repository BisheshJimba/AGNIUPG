tableextension 50424 tableextension50424 extends "Bin Content"
{
    fields
    {
        modify("Bin Code")
        {
            TableRelation = IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                             Zone Code=FIELD(Zone Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Quantity(Field 26)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pick Qty."(Field 29)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Neg. Adjmt. Qty."(Field 30)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Put-away Qty."(Field 31)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pos. Adjmt. Qty."(Field 32)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Quantity (Base)"(Field 50)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pick Quantity (Base)"(Field 51)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Negative Adjmt. Qty. (Base)"(Field 52)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Put-away Quantity (Base)"(Field 53)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Positive Adjmt. Qty. (Base)"(Field 54)".


        //Unsupported feature: Property Modification (CalcFormula) on ""ATO Components Pick Qty."(Field 55)".


        //Unsupported feature: Property Modification (CalcFormula) on ""ATO Components Pick Qty (Base)"(Field 56)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        field(50000;"Item Description";Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE (No.=FIELD(Item No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001;"Has Multiple Bin";Boolean)
        {
            Description = '//Used for syncing Qty. between whse. and ILE.';
        }
        field(50002;Inventory;Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(Item No.),
                                                                  Location Code=FIELD(Location Code)));
            Caption = 'Inventory';
            DecimalPlaces = 0:5;
            Description = '//Used for syncing purpose';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    //Unsupported feature: Property Modification (Length) on "ShowBinContents(PROCEDURE 7).VariantCode(Parameter 1004)".


    //Unsupported feature: Property Modification (Length) on "GetItemDescr(PROCEDURE 20).VariantCode(Parameter 1005)".

}

