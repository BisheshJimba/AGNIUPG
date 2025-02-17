tableextension 50352 tableextension50352 extends "Item Statistics Buffer"
{
    // 27.02.2013 EBLV7.00.00
    //   Bug fixed - was option - ' ' in "Item Ledger Entry Type Filter",
    //      so function "ConvertOptionNameToNo" in codeunit "Analysis Report Management" worked incorrect - all OptionName after 7th option consist number 7
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Filter"(Field 3)".

        modify("Item Ledger Entry Type Filter")
        {
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output,_,Assembly Consumption,Assembly Output';

            //Unsupported feature: Property Modification (OptionString) on ""Item Ledger Entry Type Filter"(Field 11)".

        }
        modify("Source No. Filter")
        {
            TableRelation = IF (Source Type Filter=CONST(Customer)) Customer
                            ELSE IF (Source Type Filter=CONST(Vendor)) Vendor
                            ELSE IF (Source Type Filter=CONST(Item)) Item;
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Invoiced Quantity"(Field 15)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Sales Amount (Actual)"(Field 16)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cost Amount (Actual)"(Field 17)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cost Amount (Non-Invtbl.)"(Field 18)".

        modify("Line Option")
        {
            OptionCaption = 'Profit Calculation,Cost Specification,Purch. Item Charge Spec.,Sales Item Charge Spec.,Period,Location,Sales Qty.';

            //Unsupported feature: Property Modification (OptionString) on ""Line Option"(Field 40)".

        }

        //Unsupported feature: Property Modification (CalcFormula) on "Quantity(Field 45)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Sales Amount (Expected)"(Field 46)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cost Amount (Expected)"(Field 47)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Budgeted Quantity"(Field 50)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Budgeted Sales Amount"(Field 51)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Budgeted Cost Amount"(Field 52)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Analysis - Quantity"(Field 80)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Analysis - Invoiced Quantity"(Field 81)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Analysis - Sales Amt. (Actual)"(Field 82)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Analysis - Sales Amt. (Exp)"(Field 83)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Analysis - Cost Amt. (Actual)"(Field 84)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Analysis - Cost Amt. (Exp)"(Field 85)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Analysis CostAmt.(Non-Invtbl.)"(Field 86)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Analysis - Budgeted Quantity"(Field 91)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Analysis - Budgeted Sales Amt."(Field 92)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Analysis - Budgeted Cost Amt."(Field 93)".

        field(25006000;"Sales (Qty.)";Integer)
        {
            Caption = 'Sales (Qty.)';
        }
    }
}

