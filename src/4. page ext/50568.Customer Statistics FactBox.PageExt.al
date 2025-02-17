pageextension 50568 pageextension50568 extends "Customer Statistics FactBox"
{
    layout
    {
        addfirst(Sales)
        {
            field("Balance (LCY) With VAT"; BalanceLCYWithVAT)
            {
            }
        }
    }

    var
        BalanceLCYWithVAT: Decimal;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    FILTERGROUP(4);
    DateFilterSet := GETFILTER("Date Filter") <> '';
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    FILTERGROUP(4);
    DateFilterSet := GETFILTER("Date Filter") <> '';
    BalanceLCYWithVAT := "Balance (LCY)" + "Balance (LCY)"*13.0/100;  //AGNI2017CU8
    */
    //end;


    //Unsupported feature: Code Insertion on "OnFindRecord".

    //trigger OnFindRecord()
    //Parameters and return type have not been exported.
    //begin
    /*
    BalanceLCYWithVAT := 0;  //AGNI2017CU8
    */
    //end;
}

