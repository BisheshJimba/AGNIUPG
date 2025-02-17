codeunit 25006504 "Lost Sales Management"
{

    trigger OnRun()
    begin
    end;

    var
        LostSalesEntry: Record "25006747";
        LostSalesSetup: Record "25006753";
        Text100: Label 'Is this a lost sale?';
        Text110: Label 'Item %1. Is this a lost sale?';

    [Scope('Internal')]
    procedure RegisterLostSale_Item(ItemNo: Code[20])
    var
        LostSaleReg_Item: Page "25006860";
    begin
        CLEAR(LostSaleReg_Item);
        LostSaleReg_Item.SetItem(ItemNo);
        LostSaleReg_Item.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure CreateEntry_Item(EntryDate: Date; ItemNo: Code[20]; CustNo: Code[20]; Desc: Text[50]; Desc2: Text[50]; ReasonCode: Code[20]; Priority: Option ,Highest,High,Mediun,Low,Lowest; Automatic: Boolean; Advance: Boolean; Qty: Decimal)
    var
        EntryNo: Integer;
        Item: Record "27";
        UserSetup: Record "91";
    begin
        LostSalesEntry.RESET;
        LostSalesEntry.LOCKTABLE;
        IF LostSalesEntry.FINDLAST THEN
            EntryNo := LostSalesEntry."Entry No.";

        EntryNo := EntryNo + 1;

        LostSalesEntry.INIT;
        LostSalesEntry."Entry No." := EntryNo;
        LostSalesEntry.Date := EntryDate;
        LostSalesEntry."Item No." := ItemNo;
        IF Item.GET(ItemNo) THEN BEGIN
            LostSalesEntry."Item Category Code" := Item."Item Category Code";
            LostSalesEntry."Product Group Code" := Item."Product Group Code";
            LostSalesEntry."Product Subgroup Code" := Item."Product Subgroup Code";
            LostSalesEntry.Description := Item.Description;
        END;
        LostSalesEntry.VALIDATE("Customer No.", CustNo);
        //LostSalesEntry.Description := Desc;
        LostSalesEntry."Description 2" := Desc2;
        LostSalesEntry."Reason Code" := ReasonCode;
        LostSalesEntry.Priority := Priority;
        LostSalesEntry.Automatic := Automatic;
        LostSalesEntry."Assigned User Id" := USERID;
        LostSalesEntry.Advance := Advance;
        LostSalesEntry.Quantity := Qty;
        //agile
        IF UserSetup.GET(USERID) THEN
            LostSalesEntry."Location Code" := UserSetup."Default Location";

        LostSalesEntry.INSERT;
    end;

    [Scope('Internal')]
    procedure OnServLineDelete(ServLine: Record "25006146")
    var
        ServHeader: Record "25006145";
    begin
        /*IF ServLine.Type <> ServLine.Type::Item THEN
         EXIT;
        
        ServHeader.RESET;
        ServHeader.GET(ServLine."Document Type",ServLine."Document No.");
        IF NOT LostSalesSetup.GET THEN
          EXIT;
        CASE LostSalesSetup."On Service Doc. Deletion" OF
         LostSalesSetup."On Service Doc. Deletion"::Prompt:
           IF CONFIRM(Text110,TRUE,ServLine."No.") THEN
             CreateEntry_Item(WORKDATE,ServLine."No.",ServHeader."Sell-to Customer No.",'','','',3,TRUE,FALSE);
         LostSalesSetup."On Service Doc. Deletion"::Yes:
            CreateEntry_Item(WORKDATE,ServLine."No.",ServHeader."Sell-to Customer No.",'','','',3,TRUE,FALSE);
        END;*/

    end;

    [Scope('Internal')]
    procedure OnSalesLineDelete(SalesLine: Record "37")
    begin
        /*IF SalesLine.Type <> SalesLine.Type::Item THEN
         EXIT;
        
        IF NOT LostSalesSetup.GET THEN
          EXIT;
        CASE LostSalesSetup."On Sales Doc. Deletion" OF
         LostSalesSetup."On Sales Doc. Deletion"::Prompt:
           IF CONFIRM(Text110,TRUE,SalesLine."No.") THEN
             CreateEntry_Item(WORKDATE,SalesLine."No.",SalesLine."Sell-to Customer No.",'','','',3,TRUE,FALSE);
         LostSalesSetup."On Sales Doc. Deletion"::Yes:
            CreateEntry_Item(WORKDATE,SalesLine."No.",SalesLine."Sell-to Customer No.",'','','',3,TRUE,FALSE);
        END;
        */

    end;

    [Scope('Internal')]
    procedure OnServHeaderDelete(ServHeader: Record "25006145")
    var
        ServLine: Record "25006146";
    begin
        /*IF NOT LostSalesSetup.GET THEN
          EXIT;
        
        IF LostSalesSetup."On Service Doc. Deletion" = LostSalesSetup."On Service Doc. Deletion"::No THEN
         EXIT;
        
        IF LostSalesSetup."On Service Doc. Deletion" = LostSalesSetup."On Service Doc. Deletion"::Prompt THEN
          IF NOT CONFIRM(Text100) THEN
            EXIT;
        
        ServLine.RESET;
        ServLine.SETRANGE("Document Type",ServHeader."Document Type");
        ServLine.SETRANGE("Document No.",ServHeader."No.");
        ServLine.SETRANGE(Type,ServLine.Type::Item);
        IF ServLine.FINDFIRST THEN
         REPEAT
          CreateEntry_Item(WORKDATE,ServLine."No.",ServHeader."Sell-to Customer No.",'','','',3,TRUE,FALSE);
         UNTIL ServLine.NEXT = 0;
         */

    end;

    [Scope('Internal')]
    procedure OnSalesHeaderDelete(SalesHeader: Record "36")
    var
        SalesLine: Record "37";
    begin
        /*IF SalesHeader."Document Profile" = SalesHeader."Document Profile"::"Vehicles Trade" THEN
          EXIT;
        
        IF NOT LostSalesSetup.GET THEN
          EXIT;
        
        IF LostSalesSetup."On Sales Doc. Deletion" = LostSalesSetup."On Sales Doc. Deletion"::No THEN
         EXIT;
        
        IF LostSalesSetup."On Sales Doc. Deletion" = LostSalesSetup."On Sales Doc. Deletion"::Prompt THEN
          IF NOT CONFIRM(Text100) THEN
            EXIT;
        
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.",SalesHeader."No.");
        SalesLine.SETRANGE(Type,SalesLine.Type::Item);
        IF SalesLine.FINDFIRST THEN
         REPEAT
          CreateEntry_Item(WORKDATE,SalesLine."No.",SalesHeader."Sell-to Customer No.",'','','',3,TRUE,FALSE);
         UNTIL SalesLine.NEXT = 0;
         */

    end;
}

