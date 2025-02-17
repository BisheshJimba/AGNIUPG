tableextension 50323 tableextension50323 extends "Stockkeeping Unit"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 2)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 53)".


        //Unsupported feature: Property Modification (CalcFormula) on "Inventory(Field 68)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Purch. Order"(Field 84)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Sales Order"(Field 85)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Assembly Order"(Field 977)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Asm. Component"(Field 978)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Job Order"(Field 1001)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Scheduled Receipt (Qty.)"(Field 5420)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Scheduled Need (Qty.)"(Field 5421)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. in Transit"(Field 5701)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Trans. Ord. Receipt (Qty.)"(Field 5702)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Trans. Ord. Shipment (Qty.)"(Field 5703)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Service Order"(Field 5901)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Last Phys. Invt. Date"(Field 7383)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Planned Order Receipt (Qty.)"(Field 99000765)".


        //Unsupported feature: Property Modification (CalcFormula) on ""FP Order Receipt (Qty.)"(Field 99000766)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Rel. Order Receipt (Qty.)"(Field 99000767)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Planned Order Release (Qty.)"(Field 99000769)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Purch. Req. Receipt (Qty.)"(Field 99000770)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Purch. Req. Release (Qty.)"(Field 99000771)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Prod. Order"(Field 99000777)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Component Lines"(Field 99000778)".

        field(7; "Inventory Posting Group"; Text[30])
        {
            CalcFormula = Lookup(Item."Inventory Posting Group" WHERE(No.=FIELD(Item No.)));
            Caption = 'Inventory Posting Group';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000;"Item Classified";Boolean)
        {
        }
        field(33019831;"Average Issue Per Month";Decimal)
        {
            Editable = false;
        }
        field(33019832;"Item Class Based On Avg Issue";Option)
        {
            Editable = false;
            OptionCaption = ' ,N,S,M,F';
            OptionMembers = " ",N,S,M,F;
        }
    }
}

