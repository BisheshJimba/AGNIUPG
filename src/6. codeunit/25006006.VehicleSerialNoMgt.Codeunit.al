codeunit 25006006 "Vehicle Serial No. Mgt."
{
    // 21.01.2015 EDMS P11
    //   Fixed bug. After recreate Sales Line tracking - lost information in field "Appl.-from Item Entry"
    //   Changed functions:
    //     fDeleteSalesLineTracking
    //     fCreateSalesLineTracking


    trigger OnRun()
    begin
    end;

    var
        tcDMS001: Label 'DMS generated entry';

    [Scope('Internal')]
    procedure fGetNewNo(): Code[20]
    var
        recInvSetup: Record "313";
        cuNoSeriesMgt: Codeunit "396";
        codSerialNo: Code[20];
    begin
        recInvSetup.GET;
        recInvSetup.TESTFIELD("Vehicle Serial No. Nos.");
        cuNoSeriesMgt.InitSeries(recInvSetup."Vehicle Serial No. Nos.", recInvSetup."Vehicle Serial No. Nos.",
         WORKDATE, codSerialNo, recInvSetup."Vehicle Serial No. Nos.");

        EXIT(codSerialNo);
    end;

    [Scope('Internal')]
    procedure fDeletePurchLineTracking(var recPurchLine: Record "39")
    var
        recReservEntry: Record "337";
    begin
        recPurchLine.TESTFIELD("Document No.");
        recPurchLine.TESTFIELD("Line No.");
        recPurchLine.TESTFIELD("Line Type", recPurchLine."Line Type"::Vehicle);

        recReservEntry.RESET;
        recReservEntry.LOCKTABLE;
        recReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
         "Source Prod. Order Line", "Reservation Status");

        recReservEntry.SETRANGE("Source ID", recPurchLine."Document No.");
        recReservEntry.SETRANGE("Source Ref. No.", recPurchLine."Line No.");
        recReservEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
        recReservEntry.SETRANGE("Source Subtype", recPurchLine."Document Type");
        recReservEntry.SETRANGE("Source Batch Name", '');
        recReservEntry.SETRANGE("Source Prod. Order Line", 0);
        recReservEntry.SETRANGE("Reservation Status", recReservEntry."Reservation Status"::Surplus);

        recReservEntry.DELETEALL;
    end;

    [Scope('Internal')]
    procedure fCreatePurchLineTracking(var recPurchLine: Record "39")
    var
        intNewEntryNo: Integer;
        recReservEntry: Record "337";
    begin
        recPurchLine.TESTFIELD("Document No.");
        recPurchLine.TESTFIELD("Line No.");
        recPurchLine.TESTFIELD("Line Type", recPurchLine."Line Type"::Vehicle);
        recPurchLine.TESTFIELD("No.");
        recPurchLine.TESTFIELD("Vehicle Serial No.");
        recPurchLine.TESTFIELD(Quantity, 1);

        recReservEntry.RESET;
        recReservEntry.LOCKTABLE;
        intNewEntryNo := fGetLastEntryNo(recReservEntry) + 1;
        recReservEntry.INIT;
        recReservEntry."Entry No." := intNewEntryNo;
        recReservEntry.Positive := TRUE;
        recReservEntry."Item No." := recPurchLine."No.";
        recReservEntry."Location Code" := recPurchLine."Location Code";
        IF (recPurchLine."Document Type" = recPurchLine."Document Type"::Order)
           OR (recPurchLine."Document Type" = recPurchLine."Document Type"::Invoice) THEN BEGIN
            recReservEntry."Quantity (Base)" := recPurchLine.Quantity;
            recReservEntry.Quantity := recPurchLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := recPurchLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := recPurchLine."Qty. to Invoice";
            recReservEntry."Quantity Invoiced (Base)" := recPurchLine."Quantity Invoiced";
        END
        ELSE //Credit Memo, Return Order
         BEGIN
            recReservEntry."Quantity (Base)" := -recPurchLine.Quantity;
            recReservEntry.Quantity := -recPurchLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := -recPurchLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := -recPurchLine."Qty. to Invoice";
            recReservEntry."Quantity Invoiced (Base)" := -recPurchLine."Quantity Invoiced";
        END;
        recReservEntry."Reservation Status" := recReservEntry."Reservation Status"::Surplus;
        recReservEntry.Description := tcDMS001;
        recReservEntry."Creation Date" := WORKDATE;
        recReservEntry."Transferred from Entry No." := 0;
        recReservEntry."Source Type" := DATABASE::"Purchase Line";
        recReservEntry."Source Subtype" := recPurchLine."Document Type";
        recReservEntry."Source ID" := recPurchLine."Document No.";
        recReservEntry."Source Batch Name" := '';
        recReservEntry."Source Prod. Order Line" := 0;
        recReservEntry."Source Ref. No." := recPurchLine."Line No.";
        recReservEntry."Item Ledger Entry No." := 0;
        recReservEntry."Expected Receipt Date" := WORKDATE;
        recReservEntry."Shipment Date" := 0D;
        recReservEntry."Serial No." := recPurchLine."Vehicle Serial No.";
        recReservEntry."Created By" := USERID;
        recReservEntry."Changed By" := '';
        recReservEntry."Qty. per Unit of Measure" := recPurchLine."Qty. per Unit of Measure";
        recReservEntry.Binding := 0;
        recReservEntry."Suppressed Action Msg." := FALSE;
        recReservEntry."Planning Flexibility" := recReservEntry."Planning Flexibility"::Unlimited;
        recReservEntry."Warranty Date" := 0D;
        recReservEntry."Expiration Date" := 0D;
        // recReservEntry."Reserved Pick & Ship Qty." := 0;//30.10.2012 EDMS
        recReservEntry."New Serial No." := '';
        recReservEntry."New Lot No." := '';
        recReservEntry."Lot No." := '';
        recReservEntry."Variant Code" := recPurchLine."Variant Code";
        recReservEntry.Correction := FALSE;
        recReservEntry."Action Message Adjustment" := 0;
        recReservEntry.INSERT;
    end;

    [Scope('Internal')]
    procedure fDeleteTransferLineTracking(var recTransferLine: Record "5741")
    var
        recReservEntry: Record "337";
    begin
        recTransferLine.TESTFIELD("Document No.");
        recTransferLine.TESTFIELD("Line No.");
        recTransferLine.TESTFIELD("Document Profile", recTransferLine."Document Profile"::"Vehicles Trade");

        recReservEntry.RESET;
        recReservEntry.LOCKTABLE;
        recReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
         "Source Prod. Order Line", "Reservation Status");

        recReservEntry.SETRANGE("Source ID", recTransferLine."Document No.");
        recReservEntry.SETRANGE("Source Ref. No.", recTransferLine."Line No.");
        recReservEntry.SETRANGE("Source Type", DATABASE::"Transfer Line");
        recReservEntry.SETRANGE("Source Subtype");
        recReservEntry.SETRANGE("Source Batch Name", '');
        recReservEntry.SETRANGE("Source Prod. Order Line", 0);
        recReservEntry.SETRANGE("Reservation Status", recReservEntry."Reservation Status"::Surplus);

        recReservEntry.DELETEALL;
    end;

    [Scope('Internal')]
    procedure fCreateTransferLineTracking(var recTransferLine: Record "5741")
    var
        intNewEntryNo: Integer;
        recReservEntry: Record "337";
    begin
        recTransferLine.TESTFIELD("Document No.");
        recTransferLine.TESTFIELD("Line No.");
        recTransferLine.TESTFIELD("Document Profile", recTransferLine."Document Profile"::"Vehicles Trade");
        recTransferLine.TESTFIELD("Item No.");
        recTransferLine.TESTFIELD("Vehicle Serial No.");
        recTransferLine.TESTFIELD(Quantity, 1);

        recReservEntry.RESET;
        recReservEntry.LOCKTABLE;
        intNewEntryNo := fGetLastEntryNo(recReservEntry) + 1;
        recReservEntry.INIT;
        recReservEntry."Entry No." := intNewEntryNo;
        recReservEntry.Positive := FALSE;
        recReservEntry."Item No." := recTransferLine."Item No.";
        recReservEntry."Location Code" := recTransferLine."Transfer-from Code";
        recReservEntry."Quantity (Base)" := -recTransferLine.Quantity;
        recReservEntry."Reservation Status" := recReservEntry."Reservation Status"::Surplus;
        recReservEntry.Description := tcDMS001;
        recReservEntry."Creation Date" := WORKDATE;
        recReservEntry."Transferred from Entry No." := 0;
        recReservEntry."Source Type" := DATABASE::"Transfer Line";
        recReservEntry."Source Subtype" := 0; //!
        recReservEntry."Source ID" := recTransferLine."Document No.";
        recReservEntry."Source Batch Name" := '';
        recReservEntry."Source Prod. Order Line" := 0;
        recReservEntry."Source Ref. No." := recTransferLine."Line No.";
        recReservEntry."Item Ledger Entry No." := 0;
        //recReservEntry."Expected Receipt Date" := WORKDATE;
        recReservEntry."Shipment Date" := 0D;
        recReservEntry."Serial No." := recTransferLine."Vehicle Serial No.";
        recReservEntry."Created By" := USERID;
        recReservEntry."Changed By" := '';
        recReservEntry."Qty. per Unit of Measure" := recTransferLine."Qty. per Unit of Measure";
        recReservEntry.Quantity := -recTransferLine.Quantity;
        recReservEntry.Binding := 0;
        recReservEntry."Suppressed Action Msg." := FALSE;
        recReservEntry."Planning Flexibility" := recReservEntry."Planning Flexibility"::Unlimited;
        recReservEntry."Warranty Date" := 0D;
        recReservEntry."Expiration Date" := 0D;
        recReservEntry."Qty. to Handle (Base)" := -recTransferLine.Quantity;
        recReservEntry."Qty. to Invoice (Base)" := -recTransferLine.Quantity;
        // recReservEntry."Reserved Pick & Ship Qty." := 0;//30.10.2012 EDMS
        recReservEntry."New Serial No." := '';
        recReservEntry."New Lot No." := '';
        recReservEntry."Lot No." := '';
        recReservEntry."Variant Code" := recTransferLine."Variant Code";
        recReservEntry.Correction := FALSE;
        recReservEntry."Action Message Adjustment" := 0;
        recReservEntry.INSERT;

        intNewEntryNo := intNewEntryNo + 1;
        recReservEntry.INIT;
        recReservEntry."Entry No." := intNewEntryNo;
        recReservEntry.Positive := TRUE;
        recReservEntry."Item No." := recTransferLine."Item No.";
        recReservEntry."Location Code" := recTransferLine."Transfer-to Code";
        recReservEntry."Quantity (Base)" := recTransferLine.Quantity;
        recReservEntry."Reservation Status" := recReservEntry."Reservation Status"::Surplus;
        recReservEntry.Description := tcDMS001;
        recReservEntry."Creation Date" := WORKDATE;
        recReservEntry."Transferred from Entry No." := 0;
        recReservEntry."Source Type" := DATABASE::"Transfer Line";
        recReservEntry."Source Subtype" := 1; //!
        recReservEntry."Source ID" := recTransferLine."Document No.";
        recReservEntry."Source Batch Name" := '';
        recReservEntry."Source Prod. Order Line" := 0;
        recReservEntry."Source Ref. No." := recTransferLine."Line No.";
        recReservEntry."Item Ledger Entry No." := 0;
        //recReservEntry."Expected Receipt Date" := WORKDATE;
        recReservEntry."Shipment Date" := 0D;
        recReservEntry."Serial No." := recTransferLine."Vehicle Serial No.";
        recReservEntry."Created By" := USERID;
        recReservEntry."Changed By" := '';
        recReservEntry."Qty. per Unit of Measure" := recTransferLine."Qty. per Unit of Measure";
        recReservEntry.Quantity := recTransferLine.Quantity;
        recReservEntry.Binding := 0;
        recReservEntry."Suppressed Action Msg." := FALSE;
        recReservEntry."Planning Flexibility" := recReservEntry."Planning Flexibility"::Unlimited;
        recReservEntry."Warranty Date" := 0D;
        recReservEntry."Expiration Date" := 0D;
        recReservEntry."Qty. to Handle (Base)" := recTransferLine.Quantity;
        recReservEntry."Qty. to Invoice (Base)" := recTransferLine.Quantity;
        // recReservEntry."Reserved Pick & Ship Qty." := 0;//30.10.2012 EDMS
        recReservEntry."New Serial No." := '';
        recReservEntry."New Lot No." := '';
        recReservEntry."Lot No." := '';
        recReservEntry."Variant Code" := recTransferLine."Variant Code";
        recReservEntry.Correction := FALSE;
        recReservEntry."Action Message Adjustment" := 0;
        recReservEntry.INSERT;
    end;

    [Scope('Internal')]
    procedure fGetLastEntryNo(var recReservEntry: Record "337"): Integer
    begin
        recReservEntry.RESET;
        IF recReservEntry.FINDLAST THEN
            EXIT(recReservEntry."Entry No.")
    end;

    [Scope('Internal')]
    procedure fDeleteSalesLineTracking(var recSalesLine: Record "37")
    var
        recReservEntry: Record "337";
    begin
        recSalesLine.TESTFIELD("Document No.");
        recSalesLine.TESTFIELD("Line No.");
        recSalesLine.TESTFIELD("Line Type", recSalesLine."Line Type"::Vehicle);

        recReservEntry.RESET;
        recReservEntry.LOCKTABLE;
        recReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
         "Source Prod. Order Line", "Reservation Status");

        recReservEntry.SETRANGE("Source ID", recSalesLine."Document No.");
        recReservEntry.SETRANGE("Source Ref. No.", recSalesLine."Line No.");
        recReservEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
        recReservEntry.SETRANGE("Source Subtype", recSalesLine."Document Type");
        recReservEntry.SETRANGE("Source Batch Name", '');
        recReservEntry.SETRANGE("Source Prod. Order Line", 0);
        recReservEntry.SETRANGE("Reservation Status", recReservEntry."Reservation Status"::Surplus);

        // 21.01.2015 EDMS P11 >>
        IF recReservEntry.FINDFIRST THEN
            IF recSalesLine."Appl.-from Item Entry" = 0 THEN
                recSalesLine."Appl.-from Item Entry" := recReservEntry."Appl.-from Item Entry";  //28.08.2013 EDMS P8
        // 21.01.2015 EDMS P11 <<

        recReservEntry.DELETEALL;
    end;

    [Scope('Internal')]
    procedure fCreateSalesLineTracking(var recSalesLine: Record "37")
    var
        intNewEntryNo: Integer;
        recReservEntry: Record "337";
    begin
        recSalesLine.TESTFIELD("Document No.");
        recSalesLine.TESTFIELD("Line No.");
        recSalesLine.TESTFIELD("Line Type", recSalesLine."Line Type"::Vehicle);
        recSalesLine.TESTFIELD("No.");
        recSalesLine.TESTFIELD("Vehicle Serial No.");
        recSalesLine.TESTFIELD(Quantity, 1);

        recReservEntry.RESET;
        recReservEntry.LOCKTABLE;
        intNewEntryNo := fGetLastEntryNo(recReservEntry) + 1;
        recReservEntry.INIT;
        recReservEntry."Entry No." := intNewEntryNo;
        recReservEntry.Positive := TRUE;
        recReservEntry."Item No." := recSalesLine."No.";
        recReservEntry."Location Code" := recSalesLine."Location Code";

        IF (recSalesLine."Document Type" = recSalesLine."Document Type"::Order)
          OR (recSalesLine."Document Type" = recSalesLine."Document Type"::Invoice) THEN BEGIN
            recReservEntry."Quantity (Base)" := -recSalesLine.Quantity;
            recReservEntry.Quantity := -recSalesLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := -recSalesLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := -recSalesLine."Qty. to Invoice";
            recReservEntry."Quantity Invoiced (Base)" := -recSalesLine."Quantity Invoiced";
        END
        ELSE //Credit Memo, Return Order
         BEGIN
            recReservEntry."Quantity (Base)" := recSalesLine.Quantity;
            recReservEntry.Quantity := recSalesLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := recSalesLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := recSalesLine."Qty. to Invoice";
            recReservEntry."Quantity Invoiced (Base)" := recSalesLine."Quantity Invoiced";
        END;

        recReservEntry."Reservation Status" := recReservEntry."Reservation Status"::Surplus;
        recReservEntry.Description := tcDMS001;
        recReservEntry."Creation Date" := WORKDATE;
        recReservEntry."Transferred from Entry No." := 0;
        recReservEntry."Source Type" := DATABASE::"Sales Line";
        recReservEntry."Source Subtype" := recSalesLine."Document Type";
        recReservEntry."Source ID" := recSalesLine."Document No.";
        recReservEntry."Source Batch Name" := '';
        recReservEntry."Source Prod. Order Line" := 0;
        recReservEntry."Source Ref. No." := recSalesLine."Line No.";
        // 21.01.2015 EDMS P11 >>
        recReservEntry."Appl.-to Item Entry" := 0;
        recReservEntry."Appl.-from Item Entry" := recSalesLine."Appl.-from Item Entry";
        // 21.01.2015 EDMS P11 <<
        recReservEntry."Item Ledger Entry No." := 0;
        recReservEntry."Expected Receipt Date" := WORKDATE;
        recReservEntry."Shipment Date" := 0D;
        recReservEntry."Serial No." := recSalesLine."Vehicle Serial No.";
        recReservEntry."Created By" := USERID;
        recReservEntry."Changed By" := '';
        recReservEntry."Qty. per Unit of Measure" := recSalesLine."Qty. per Unit of Measure";
        recReservEntry.Binding := 0;
        recReservEntry."Suppressed Action Msg." := FALSE;
        recReservEntry."Planning Flexibility" := recReservEntry."Planning Flexibility"::Unlimited;
        recReservEntry."Warranty Date" := 0D;
        recReservEntry."Expiration Date" := 0D;
        // recReservEntry."Reserved Pick & Ship Qty." := 0;//30.10.2012 EDMS
        recReservEntry."New Serial No." := '';
        recReservEntry."New Lot No." := '';
        recReservEntry."Lot No." := '';
        recReservEntry."Variant Code" := recSalesLine."Variant Code";
        recReservEntry.Correction := FALSE;
        recReservEntry."Action Message Adjustment" := 0;
        recReservEntry.INSERT;
    end;

    [Scope('Internal')]
    procedure fDeleteItemJnlLineTracking(var ItemJnlLine: Record "83")
    var
        recReservEntry: Record "337";
    begin
        ItemJnlLine.TESTFIELD("Document No.");
        ItemJnlLine.TESTFIELD("Line No.");
        ItemJnlLine.TESTFIELD("Item No.");
        ItemJnlLine.TESTFIELD("Model Version No.");

        recReservEntry.RESET;
        recReservEntry.LOCKTABLE;
        recReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
         "Source Prod. Order Line", "Reservation Status");

        recReservEntry.SETRANGE("Source ID", ItemJnlLine."Journal Template Name");
        recReservEntry.SETRANGE("Source Ref. No.", ItemJnlLine."Line No.");
        recReservEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
        recReservEntry.SETRANGE("Source Subtype", 2);//!!
        recReservEntry.SETRANGE("Source Batch Name", ItemJnlLine."Journal Batch Name");
        recReservEntry.SETRANGE("Source Prod. Order Line", 0);
        recReservEntry.SETRANGE("Reservation Status", recReservEntry."Reservation Status"::Prospect);

        recReservEntry.DELETEALL;
    end;

    [Scope('Internal')]
    procedure fCreateItemJnlLineTracking(var ItemJnlLine: Record "83")
    var
        intNewEntryNo: Integer;
        recReservEntry: Record "337";
    begin
        ItemJnlLine.TESTFIELD("Document No.");
        ItemJnlLine.TESTFIELD("Line No.");
        ItemJnlLine.TESTFIELD("Model Version No.");
        ItemJnlLine.TESTFIELD("Item No.");
        ItemJnlLine.TESTFIELD("Vehicle Serial No.");
        IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Positive Adjmt." THEN BEGIN
            IF ItemJnlLine.Quantity = 0 THEN
                ItemJnlLine.TESTFIELD("Qty. (Calculated)", ItemJnlLine."Qty. (Phys. Inventory)");
        END ELSE
            ItemJnlLine.TESTFIELD(Quantity, 1);

        recReservEntry.RESET;
        recReservEntry.LOCKTABLE;
        intNewEntryNo := fGetLastEntryNo(recReservEntry) + 1;
        recReservEntry.INIT;
        recReservEntry."Entry No." := intNewEntryNo;
        recReservEntry.Positive := TRUE;
        recReservEntry."Item No." := ItemJnlLine."Item No.";
        recReservEntry."Location Code" := ItemJnlLine."Location Code";

        IF (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Sale)
          OR (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Negative Adjmt.") THEN BEGIN
            recReservEntry."Quantity (Base)" := -ItemJnlLine.Quantity;
            recReservEntry.Quantity := -ItemJnlLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := -ItemJnlLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := -ItemJnlLine.Quantity;
            recReservEntry."Quantity Invoiced (Base)" := -ItemJnlLine.Quantity;
        END
        ELSE //positive adjustment, purchase
         BEGIN
            recReservEntry."Quantity (Base)" := ItemJnlLine.Quantity;
            recReservEntry.Quantity := ItemJnlLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := ItemJnlLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := ItemJnlLine.Quantity;
            recReservEntry."Quantity Invoiced (Base)" := ItemJnlLine.Quantity;
        END;

        recReservEntry."Reservation Status" := recReservEntry."Reservation Status"::Prospect;
        recReservEntry.Description := tcDMS001;
        recReservEntry."Creation Date" := WORKDATE;
        recReservEntry."Transferred from Entry No." := 0;
        recReservEntry."Source Type" := DATABASE::"Item Journal Line";
        recReservEntry."Source Subtype" := 2;   //!!!
        recReservEntry."Source ID" := ItemJnlLine."Journal Template Name";
        recReservEntry."Source Batch Name" := ItemJnlLine."Journal Batch Name";
        recReservEntry."Source Prod. Order Line" := 0;
        recReservEntry."Source Ref. No." := ItemJnlLine."Line No.";
        recReservEntry."Item Ledger Entry No." := 0;
        recReservEntry."Expected Receipt Date" := WORKDATE;
        recReservEntry."Shipment Date" := 0D;
        recReservEntry."Serial No." := ItemJnlLine."Vehicle Serial No.";
        recReservEntry."Created By" := USERID;
        recReservEntry."Changed By" := '';
        recReservEntry."Qty. per Unit of Measure" := ItemJnlLine."Qty. per Unit of Measure";
        recReservEntry.Binding := 0;
        recReservEntry."Suppressed Action Msg." := FALSE;
        recReservEntry."Planning Flexibility" := recReservEntry."Planning Flexibility"::Unlimited;
        recReservEntry."Warranty Date" := 0D;
        recReservEntry."Expiration Date" := 0D;
        // recReservEntry."Reserved Pick & Ship Qty." := 0;//30.10.2012 EDMS
        recReservEntry."New Serial No." := '';
        recReservEntry."New Lot No." := '';
        recReservEntry."Lot No." := '';
        recReservEntry."Variant Code" := ItemJnlLine."Variant Code";
        recReservEntry.Correction := FALSE;
        recReservEntry."Action Message Adjustment" := 0;
        recReservEntry."Appl.-to Item Entry" := ItemJnlLine."Applies-to Entry";
        recReservEntry.INSERT;
    end;
}

