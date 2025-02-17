pageextension 50570 pageextension50570 extends "Sales Line FactBox"
{
    // 17.12.2014 EDMS P12
    //   * Moved code form trigger OnLookup to OnDrillDown for field "Replacements Exist"
    //   * Added code in OnAfterGetRecord()
    // 
    // 08.09.2014 Elva baltic P8 #F0015 EDMS
    //   * Added field Item."Replacements Exist"
    layout
    {
        addafter(ItemNo)
        {
            field(VIN; VIN)
            {
            }
        }
        addafter(Item)
        {
            field(Item."Replacements Exist";
                Item."Replacements Exist")
            {
                Caption = 'Replacements Exist';

                trigger OnDrillDown()
                var
                    ItemSubstSync: Codeunit "25006513";
                    TypePar: Option Item,"Nonstock Item";
                begin
                    ItemSubstSync.ShowReplacementOverview(TypePar::"Nonstock Item", Item.GetSourceNonstockEntryNo(), '');
                end;
            }
        }
    }

    var
        Item: Record "27";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CALCFIELDS("Reserved Quantity");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF NOT Item.GET("No.") THEN  //08.09.2014 Elva baltic P8 #F0015 EDMS
      Item.INIT;
    CALCFIELDS("Reserved Quantity");

    Item.CALCFIELDS("Replacements Exist") // 17.12.2014 EDMS P12
    */
    //end;
}

