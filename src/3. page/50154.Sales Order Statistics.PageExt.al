pageextension 50154 pageextension50154 extends "Sales Order Statistics"
{
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    layout
    {
        addafter("InvDiscountAmount_General")
        {
            field("Total Line Discount Amount"; "Total Line Discount Amount")
            {
            }
        }
    }


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    RefreshOnAfterGetRecord;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    RefreshOnAfterGetRecord;
                             // VATAmount[1] := ProfitLCY[1] *0.13; //Amsa
    */
    //end;
}

