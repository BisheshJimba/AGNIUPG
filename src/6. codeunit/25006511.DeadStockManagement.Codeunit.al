codeunit 25006511 "Dead Stock Management"
{
    // 15.05.2014 Elva Baltic P21 #S0105 MMG7.00
    //   Modified function:
    //     FillDeadStockList


    trigger OnRun()
    begin
    end;

    var
        DeadStockSetup: Record "25006743";
        Text001: Label 'Dead stock item list processing:';

    [Scope('Internal')]
    procedure FillDeadStockList(var Item: Record "27"; var DeadStockBuffer: Record "25006735" temporary; ShowAll: Boolean)
    var
        StartDate: Date;
        EndDate: Date;
        Window: Dialog;
        CurrentRec: Integer;
        MaxRec: Integer;
    begin
        Window.OPEN(
          Text001 +
          '@1@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.UPDATE(1, 0);

        MaxRec := Item.COUNT;
        CurrentRec := 0;
        DeadStockSetup.GET;
        DeadStockBuffer.DELETEALL;

        IF Item.GETFILTER("Date Filter") = '' THEN BEGIN
            DeadStockSetup.TESTFIELD("Starting Date");
            DeadStockSetup.TESTFIELD("Ending Date");
            Item.SETFILTER("Date Filter", '%1..%2', DeadStockSetup."Starting Date", DeadStockSetup."Ending Date");
        END;

        IF Item.FINDSET THEN
            REPEAT
                CurrentRec += 1;
                Window.UPDATE(1, ROUND(CurrentRec / MaxRec * 10000, 1));

                Item.CALCFIELDS("Sales (Qty.)", "Purchases (Qty.)", Inventory, "Net Change", "Transferred (Qty.)", "Reserved Qty. on Inventory");

                IF (Item."Sales (Qty.)" + (-Item."Transferred (Qty.)") < DeadStockSetup."Min. Dead Stock Rate")
                   OR (Item."Sales (Qty.)" + (-Item."Transferred (Qty.)") = 0) OR ShowAll
                THEN BEGIN
                    DeadStockBuffer.INIT;
                    DeadStockBuffer."Item No." := Item."No.";
                    DeadStockBuffer."Sales (Qty.)" := Item."Sales (Qty.)";
                    DeadStockBuffer."Purchase (Qty.)" := Item."Purchases (Qty.)";
                    DeadStockBuffer."Transferred (Qty.)" := -Item."Transferred (Qty.)";
                    DeadStockBuffer."Net Change" := Item."Net Change";
                    DeadStockBuffer.Inventory := Item.Inventory;
                    DeadStockBuffer."Reserved on Inventory" := Item."Reserved Qty. on Inventory";
                    DeadStockBuffer."Available Inventory" := Item.Inventory - Item."Reserved Qty. on Inventory";
                    DeadStockBuffer."Item Category Code" := Item."Item Category Code";
                    DeadStockBuffer."Product Group Code" := Item."Product Group Code";
                    DeadStockBuffer."Product Subgroup Code" := Item."Product Subgroup Code";
                    DeadStockBuffer."Unit Cost" := Item."Unit Cost";
                    DeadStockBuffer."Cost Amount" := Item.Inventory * Item."Unit Cost";
                    DeadStockBuffer."Reorder Point" := Item."Reorder Point";
                    DeadStockBuffer."Maximum Inventory" := Item."Maximum Inventory";
                    IF DeadStockBuffer."Sales (Qty.)" = 0 THEN BEGIN
                        DeadStockBuffer."No Sales" := TRUE;
                        DeadStockBuffer."Dead Stock Rate 2" := 0
                    END ELSE
                        DeadStockBuffer."Dead Stock Rate 2" := Item."Net Change" / Item."Sales (Qty.)";
                    DeadStockBuffer."Dead Stock Rate" := Item."Purchases (Qty.)" - Item."Sales (Qty.)" + Item."Transferred (Qty.)";
                    DeadStockBuffer.INSERT;
                END;
            UNTIL Item.NEXT = 0;
        Window.CLOSE;
    end;
}

