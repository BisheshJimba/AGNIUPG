codeunit 33019885 CodeIssue
{
    TableNo = 33019886;

    trigger OnRun()
    begin

        GblExideClaim.COPY(Rec);

        GblExideClaim.SETRANGE("Job Card No.", Rec."Job Card No.");
        IF GblExideClaim.FINDFIRST THEN BEGIN
            GblExideClaim.Issued := TRUE;
            GblExideClaim."Issue Date" := TODAY;
            GblExideClaim.MODIFY
        END;
        ScrapAmount := GblExideClaim."Scrap Amount";
        Dimension1 := GblExideClaim."Dimension 1";
        Dimension2 := GblExideClaim."Dimension 2";
        LocationCode := GblExideClaim."Location Code";
        // to update issue no and claim no.
        /*
          GblBattService.SETRANGE("Job Card No.","Job Card No.");
          IF GblBattService.FINDFIRST THEN BEGIN
             GblBattService."Claim No." := GblExideClaim."Claim No.";
             GblBattService."Issue No." := GblExideClaim."Issue No.";
             GblBattService.MODIFY
          END;
         */
        PostedJobHeader.SETRANGE("Job Card No.", Rec."Job Card No.");
        IF PostedJobHeader.FINDFIRST THEN BEGIN
            PostedJobHeader."Claim No." := GblExideClaim."Claim No.";
            PostedJobHeader."Issue No." := GblExideClaim."Issue No.";
            PostedJobHeader."Rep. Batt. Serial" := GblExideClaim."Issued Serial No.";
            PostedJobHeader."Rep. Batt. MFG" := GblExideClaim."Issued MFG";
            PostedJobHeader.MODIFY;
        END;

        // to store values in defined variables
        GblItem.SETRANGE(GblItem."No.", Rec."Battery Part No.");
        IF GblItem.FINDFIRST THEN BEGIN
            GblNo := GblItem."No.";
            GblDescription := GblItem.Description;
            GblItemCategoryCode := GblItem."Item Category Code";
            GblProductGroupCode := GblItem."Product Group Code";
            GblProductSubgroupCode := GblItem."Product Subgroup Code";
            GblItemFor := GblItem."Item For";
            ScrapNo := GblItem."Scrap No.";

        END;

        //to insert record in item Journal entry
        //InsertItemJournal();

        // to insert record in Sales Header and Sales Line
        InsertSalesHeaderLines();
        GblExideClaim."Sales Order No." := SalesHeader2."No.";
        //GblExideClaim."Sales Order Posted" := TRUE;
        GblExideClaim.MODIFY;
        COMMIT;
        MESSAGE(Text000, SalesHeader2."No.");
        EXIT;

    end;

    var
        GblExideClaim: Record "33019886";
        GblBattService: Record "33019884";
        GblItem: Record "27";
        GblItemLedgerEntry: Record "32";
        GblNo: Code[20];
        GblDescription: Text[30];
        GblItemCategoryCode: Code[10];
        GblProductGroupCode: Code[10];
        GblProductSubgroupCode: Code[10];
        GblItemFor: Option;
        GblItemJournal: Record "83";
        BatSrvSetup: Record "33019889";
        ItemJournalBatch: Record "233";
        NoSeriesMgt: Codeunit "396";
        UserSetup: Record "91";
        ScrapNo: Code[20];
        SalesHeader: Record "36";
        CustomerInfo: Record "18";
        SalesLine: Record "37";
        Location: Record "14";
        CustomerNo: Code[20];
        UnitCode: Record "5404";
        ContactBusinessRelation: Record "5054";
        NewCustomerNo: Code[20];
        PostedJobHeader: Record "33019894";
        ScrapAmount: Decimal;
        Dimension1: Code[20];
        Dimension2: Code[20];
        ResponsibilityCenter: Code[20];
        LocationCode: Code[20];
        Text000: Label 'Sales Orde %1 is created.';
        SalesHeader2: Record "36";
        SalesLine2: Record "37";

    [Scope('Internal')]
    procedure InsertItemLedgerEntry()
    begin

        /*
        GblItemLedgerEntry.INIT;
        GblItemLedgerEntry."Entry No." := GetLedgerEntryNo + 1;
        GblItemLedgerEntry."Item No." := GblNo;
        GblItemLedgerEntry.Description := GblDescription;
        GblItemLedgerEntry."Item Category Code" := GblItemCategoryCode;
        GblItemLedgerEntry."Product Group Code" := GblProductGroupCode;
        GblItemLedgerEntry."Product Subgroup Code" := GblProductSubgroupCode;
        GblItemLedgerEntry."Item For" := GblItemFor;
        GblItemLedgerEntry.Scrap := TRUE;
        GblItemLedgerEntry.INSERT;
          */

    end;

    [Scope('Internal')]
    procedure GetLedgerEntryNo(): Integer
    var
        LclGetEntryNo: Record "32";
    begin
        /*
        LclGetEntryNo.RESET;
        IF LclGetEntryNo.FINDLAST THEN
           EXIT(LclGetEntryNo."Entry No.");
        */

    end;

    [Scope('Internal')]
    procedure InsertItemJournal()
    begin
        BatSrvSetup.GET;
        GblItemJournal.RESET;
        //IF GblItemJournal."Line No." = 0 THEN
        //GblItemJournal."Line No." := 10000;


        // to insert in item journal line
        GblItemJournal.INIT;
        GblItemJournal."Posting Date" := WORKDATE;
        GblItemJournal.SETRANGE("Journal Template Name", BatSrvSetup."Journal Template Name");
        GblItemJournal.SETRANGE("Journal Batch Name", BatSrvSetup."Journal Batch Name");
        IF GblItemJournal.FIND('+') THEN BEGIN
            GblItemJournal."Document No." := GblItemJournal."Document No.";
            GblItemJournal."Line No." := GblItemJournal."Line No." + 10000;
        END ELSE BEGIN
            IF ItemJournalBatch."No. Series" <> '' THEN BEGIN
                CLEAR(NoSeriesMgt);
                GblItemJournal."Document No." := NoSeriesMgt.TryGetNextNo(ItemJournalBatch."No. Series", TODAY);
            END;
            GblItemJournal."Line No." := 10000;
        END;




        UserSetup.GET(USERID);
        GblItemJournal."Journal Template Name" := BatSrvSetup."Journal Template Name";

        GblItemJournal."Journal Batch Name" := BatSrvSetup."Journal Batch Name";


        //GblItemJournal."Item No." := GblExideClaim."Battery Part No.";
        GblItemJournal.VALIDATE("Item No.", ScrapNo);
        GblItemJournal.VALIDATE("Location Code", UserSetup."Default Location");
        GblItemJournal.Description := GblExideClaim."Battery Description";
        GblItemJournal.VALIDATE("Inventory Posting Group", BatSrvSetup."Inventory Posting Group");
        GblItemJournal."Entry Type" := BatSrvSetup."Entry Type";
        GblItemJournal.VALIDATE(Quantity, GblExideClaim."Qty.");
        //GblItemJournal."Invoiced Quantity" := GblExideClaim."Qty.";
        GblItemJournal.VALIDATE("Source Code", BatSrvSetup."Source Code");
        GblItemJournal.VALIDATE("Gen. Prod. Posting Group", BatSrvSetup."Gen. Prod. Posting Group");
        GblItemJournal."Flushing Method" := BatSrvSetup."Flushing Method";
        GblItemJournal."Document Date" := WORKDATE;
        GblItemJournal.VALIDATE("Unit Amount", ScrapAmount);
        GblItemJournal.VALIDATE("Shortcut Dimension 1 Code", Dimension1);
        GblItemJournal.VALIDATE("Shortcut Dimension 2 Code", Dimension2);
        GblItemJournal.INSERT;
    end;

    [Scope('Internal')]
    procedure InsertSalesHeaderLines()
    begin
        BatSrvSetup.GET;


        //--------------------------------------------------------------
        PostedJobHeader.SETRANGE("Job Card No.", GblExideClaim."Job Card No.");
        IF PostedJobHeader.FINDFIRST THEN BEGIN
            CustomerNo := PostedJobHeader."Customer No.";
            // to get respective customer of contacts
            ContactBusinessRelation.SETRANGE("Contact No.", CustomerNo);
            IF ContactBusinessRelation.FIND('-') THEN
                CustomerNo := ContactBusinessRelation."No.";

            UserSetup.GET(USERID);
            Location.GET(UserSetup."Default Location");
            //Location.TESTFIELD("Sales Order Nos.");
            /*
            IF (GblExideClaim."Pro-Rata %" > 0.0) AND (GblExideClaim."Pro-Rata %" < 100.0) THEN BEGIN
              SalesHeader.INIT;
              SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
              SalesHeader."No." := '';
              SalesHeader."Posting Date" := TODAY;
              SalesHeader.INSERT(TRUE);
              SalesHeader."Order Date" := TODAY;
             // SalesHeader.VALIDATE("Sell-to Customer No.",CustomerNo);
              SalesHeader.VALIDATE("Sell-to Customer No.",BatSrvSetup."Warranty Customer");
              SalesHeader."Debit Note" := TRUE;
              SalesHeader."Battery Document" := TRUE;
              SalesHeader."Warranty Claim No." :=GblExideClaim."Claim No.";
              SalesHeader."Shortcut Dimension 1 Code" := GblExideClaim."Dimension 1";
              SalesHeader."Shortcut Dimension 2 Code" := GblExideClaim."Dimension 2";
              SalesHeader."Location Code" := GblExideClaim."Location Code";
              SalesHeader."Responsibility Center" := GblExideClaim."Responsibility Center";
              SalesHeader.MODIFY;
            END;
            */
            SalesHeader2.RESET;
            SalesHeader2.INIT;
            SalesHeader2."Document Type" := SalesHeader."Document Type"::Order;
            SalesHeader2."No." := '';
            SalesHeader2."Posting Date" := TODAY;
            SalesHeader2.INSERT(TRUE);
            SalesHeader2."Order Date" := TODAY;
            IF (GblExideClaim."Pro-Rata %" > 0.0) AND (GblExideClaim."Pro-Rata %" < 100.0) THEN BEGIN
                SalesHeader2.VALIDATE("Sell-to Customer No.", CustomerNo);
            END ELSE BEGIN
                SalesHeader2.VALIDATE("Sell-to Customer No.", BatSrvSetup."Warranty Customer");
            END;

            SalesHeader2."Battery Document" := TRUE;
            SalesHeader2."External Document No." := GblExideClaim."Job Card No.";
            SalesHeader2."Warranty Claim No." := GblExideClaim."Claim No.";
            SalesHeader2."Shortcut Dimension 1 Code" := GblExideClaim."Dimension 1";
            SalesHeader2."Shortcut Dimension 2 Code" := GblExideClaim."Dimension 2";
            SalesHeader2."Location Code" := GblExideClaim."Location Code";
            SalesHeader2."Responsibility Center" := GblExideClaim."Responsibility Center";
            SalesHeader2.MODIFY;

        END;
        //MESSAGE('%1',GblExideClaim."Sales Rate");
        /*
              IF (GblExideClaim."Pro-Rata %" > 0.0) AND (GblExideClaim."Pro-Rata %" < 100.0) THEN BEGIN
                 SalesLine.INIT;
                 SalesLine."Document Type" := SalesLine."Document Type"::Order;
                 SalesLine."Document No." := SalesHeader."No.";
                 SalesLine."Line No."  := 10000;
                 SalesLine.Type := SalesLine.Type::Item;
        
                // SalesLine.VALIDATE("Bill-to Customer No.",BatSrvSetup."Warranty Customer");
        
                 SalesLine.VALIDATE("No.",GblExideClaim."Issue Part No.");
                 SalesLine.VALIDATE(Quantity,GblExideClaim."Issue Qty.");
                 SalesLine.VALIDATE("Qty. to Ship",GblExideClaim."Issue Qty.");
                 SalesLine.VALIDATE("Unit Price",GblExideClaim."Sales Rate");
                 SalesLine.VALIDATE("Line Discount %" , GblExideClaim."Pro-Rata %");
        //SalesLine.VALIDATE("Line Discount %" , 10);
                 SalesLine.INSERT(TRUE);
              END;
              */
        SalesLine2.RESET;
        SalesLine2.INIT;
        SalesLine2."Document Type" := SalesLine2."Document Type"::Order;
        SalesLine2."Document No." := SalesHeader2."No.";
        SalesLine2."Line No." := 10000;
        SalesLine2.Type := SalesLine2.Type::Item;

        //SalesLine2.VALIDATE("Sell-to Customer No.",BatSrvSetup."Warranty Customer");
        SalesLine2.VALIDATE("No.", GblExideClaim."Issue Part No.");
        SalesLine2.VALIDATE(Quantity, GblExideClaim."Issue Qty.");
        SalesLine2.VALIDATE("Qty. to Ship", GblExideClaim."Issue Qty.");
        SalesLine2.VALIDATE("Unit Price", GblExideClaim."Sales Rate");
        SalesLine2.VALIDATE("Line Discount %", GblExideClaim."Pro-Rata %");
        //SalesLine2.VALIDATE("Line Discount %" , (100 - GblExideClaim."Pro-Rata %"));
        //SalesLine.VALIDATE("Line Discount %" , 10);
        SalesLine2.INSERT(TRUE);

        //END;

    end;
}

