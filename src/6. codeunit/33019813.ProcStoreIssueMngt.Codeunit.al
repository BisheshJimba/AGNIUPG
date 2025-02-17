codeunit 33019813 "Proc. - Store Issue Mngt."
{
    // This codeunit handles store issues - general procurement.
    // 
    // Process- create item reclassification journal.
    // and then create and post item journal.

    TableNo = 33019812;

    trigger OnRun()
    begin
        GblStrReqSmryHdr.COPY(Rec);
        //Calling function to create Item Reclassification Journal and post.
        createItmRClsJrnl(GblStrReqSmryHdr);

        //Calling function to create Item Journal and post.
        createItmJrnl(GblStrReqSmryHdr);

        //Showing completion message.
        showMessage;
    end;

    var
        GblStrReqSmryHdr: Record "33019812";
        GblInvSetup: Record "313";
        GblUserSetup: Record "91";
        GblRespCntr: Record "5714";
        GblPrcStrReqMngt: Codeunit "33019812";

    [Scope('Internal')]
    procedure createItmRClsJrnl(PrmStrReqSmryHdr: Record "33019812")
    var
        LclItmJrnlLine: Record "83";
        LclItmJrnlTemplate: Record "82";
        LclItmJrnlBatch: Record "233";
        LclStrReqSmryLine: Record "33019813";
        LclNoSeriesMngt: Codeunit "396";
        LclItmJrnlPost: Codeunit "23";
    begin
        //Location transfer of Items.
        LclStrReqSmryLine.RESET;
        LclStrReqSmryLine.SETRANGE("Integration Type", PrmStrReqSmryHdr."Category Code");
        LclStrReqSmryLine.SETRANGE("Is Fixed Asset", FALSE);     //Check for FA.
        IF LclStrReqSmryLine.FIND('-') THEN BEGIN
            REPEAT
                LclItmJrnlLine.INIT;
                LclItmJrnlLine.VALIDATE("Journal Template Name", getItmRclsJrnlTemplate);
                LclItmJrnlLine.VALIDATE("Journal Batch Name", getItmRclsJrnlBatch);
                LclItmJrnlLine."Line No." := getLineNoItmRclsJrnl + 10000;
                LclItmJrnlLine."Posting Date" := TODAY;
                LclItmJrnlLine."Document Date" := TODAY;
                LclItmJrnlLine."Document No." := getItmRclsJrnlDocNo;
                LclItmJrnlLine."Entry Type" := LclItmJrnlLine."Entry Type"::Transfer;
                LclItmJrnlLine.VALIDATE("Item No.", LclStrReqSmryLine."Category Purpose");
                LclItmJrnlLine.Quantity := LclStrReqSmryLine.Quantity;
                LclItmJrnlLine.VALIDATE("Location Code", getDfltLocation);
                LclItmJrnlLine.VALIDATE("New Location Code", LclStrReqSmryLine."Per Transaction Amount");
                LclItmJrnlLine.VALIDATE("Shortcut Dimension 1 Code", getDfltDim1Code);
                LclItmJrnlLine.VALIDATE("New Shortcut Dimension 1 Code", LclStrReqSmryLine.Branch);
                LclItmJrnlLine.VALIDATE("Shortcut Dimension 2 Code", getDfltDim2Code);
                LclItmJrnlLine.VALIDATE("New Shortcut Dimension 2 Code", LclStrReqSmryLine.Department);
                LclItmJrnlLine."Unit of Measure Code" := LclStrReqSmryLine."Unit of Measure";
                LclItmJrnlLine."Summary No." := LclStrReqSmryLine."Integration Type";
                LclItmJrnlLine.INSERT;
            UNTIL LclStrReqSmryLine.NEXT = 0;
        END;

        //Calling function - postItmRclsJrnl (Post Item Reclassification Journal) to post Item Journal.
        postItmRclsJrnl(LclItmJrnlLine);

        //Calling Function in Codeunit::33019812 to change status of Store Requisition to Issued.
        GblPrcStrReqMngt.updateStrReqStatusIssue(PrmStrReqSmryHdr."Category Code");
    end;

    [Scope('Internal')]
    procedure createItmJrnl(PrmStrReqSmryHdr: Record "33019812")
    var
        LclItmJrnlLine: Record "83";
        LclItmJrnlTemplate: Record "82";
        LclItmJrnlBatch: Record "233";
        LclStrReqSmryLine: Record "33019813";
    begin
        //Posting of Item Journal.
        LclStrReqSmryLine.RESET;
        LclStrReqSmryLine.SETRANGE("Integration Type", PrmStrReqSmryHdr."Category Code");
        LclStrReqSmryLine.SETRANGE("Is Fixed Asset", FALSE);     //Check for FA.
        IF LclStrReqSmryLine.FIND('-') THEN BEGIN
            REPEAT
                LclItmJrnlLine.INIT;
                LclItmJrnlLine.VALIDATE("Journal Template Name", getItmJrnlTemplate);
                LclItmJrnlLine.VALIDATE("Journal Batch Name", getItmJrnlBatch);
                LclItmJrnlLine."Line No." := getLineNoItmJrnl + 10000;
                LclItmJrnlLine."Posting Date" := TODAY;
                LclItmJrnlLine."Document Date" := TODAY;
                LclItmJrnlLine."Document No." := getItmJrnlDocNo;
                LclItmJrnlLine."Entry Type" := LclItmJrnlLine."Entry Type"::"Negative Adjmt.";
                LclItmJrnlLine.VALIDATE("Item No.", LclStrReqSmryLine."Category Purpose");
                LclItmJrnlLine.Quantity := LclStrReqSmryLine.Quantity;
                LclItmJrnlLine.VALIDATE("Location Code", LclStrReqSmryLine."Per Transaction Amount");
                LclItmJrnlLine.VALIDATE("Shortcut Dimension 1 Code", LclStrReqSmryLine.Branch);
                LclItmJrnlLine.VALIDATE("Shortcut Dimension 2 Code", LclStrReqSmryLine.Department);
                LclItmJrnlLine."Unit of Measure Code" := LclStrReqSmryLine."Unit of Measure";
                LclItmJrnlLine."Summary No." := LclStrReqSmryLine."Integration Type";
                LclItmJrnlLine.INSERT;
            UNTIL LclStrReqSmryLine.NEXT = 0;
        END;

        //Calling function - postItmJrnl (Post Item Journal) to post Item Journal.
        postItmJrnl(LclItmJrnlLine);
    end;

    [Scope('Internal')]
    procedure getItmRclsJrnlTemplate(): Code[10]
    begin
        //Retrieving Jouranl Reclassification Template Name.
        GblInvSetup.GET;
        EXIT(GblInvSetup."Item Reclass. Journal Template");
    end;

    [Scope('Internal')]
    procedure getItmRclsJrnlBatch(): Code[10]
    begin
        //Retrieving Jouranl Reclassification Batch Name.
        GblInvSetup.GET;
        EXIT(GblInvSetup."Item Reclass. Journal Batch");
    end;

    [Scope('Internal')]
    procedure getItmJrnlTemplate(): Code[10]
    begin
        //Retrieving Jouranl Template Name.
        GblInvSetup.GET;
        EXIT(GblInvSetup."Item Journal Template");
    end;

    [Scope('Internal')]
    procedure getItmJrnlBatch(): Code[10]
    begin
        //Retrieving Jouranl Batch Name.
        GblInvSetup.GET;
        EXIT(GblInvSetup."Item Journal Batch");
    end;

    [Scope('Internal')]
    procedure getLineNoItmRclsJrnl(): Integer
    var
        LclItmJrnl: Record "83";
    begin
        //Retrieving last Line No. on the basis of Template and Batch from Item Journal Line.
        LclItmJrnl.RESET;
        LclItmJrnl.SETRANGE("Journal Template Name", getItmRclsJrnlTemplate);
        LclItmJrnl.SETRANGE("Journal Batch Name", getItmRclsJrnlBatch);
        IF LclItmJrnl.FIND('+') THEN
            EXIT(LclItmJrnl."Line No.");
    end;

    [Scope('Internal')]
    procedure getLineNoItmJrnl(): Integer
    var
        LclItmJrnl: Record "83";
    begin
        //Retrieving last Line No. on the basis of Template and Batch from Item Journal Line.
        LclItmJrnl.RESET;
        LclItmJrnl.SETRANGE("Journal Template Name", getItmJrnlTemplate);
        LclItmJrnl.SETRANGE("Journal Batch Name", getItmJrnlBatch);
        IF LclItmJrnl.FIND('+') THEN
            EXIT(LclItmJrnl."Line No.");
    end;

    [Scope('Internal')]
    procedure getItmRclsJrnlDocNo(): Code[20]
    var
        LclNoSeries: Record "308";
        LclNoSeriesLine: Record "309";
        LclItmJrnlBatch: Record "233";
        LclNoSeriesMngt: Codeunit "396";
    begin
        //Retrieving Document No. from No. Series Line table with filter from Item Journal Batch - No. Series assigned.
        LclItmJrnlBatch.RESET;
        LclItmJrnlBatch.SETRANGE("Journal Template Name", getItmRclsJrnlTemplate);
        LclItmJrnlBatch.SETRANGE(Name, getItmRclsJrnlBatch);
        IF LclItmJrnlBatch.FIND('-') THEN BEGIN
            LclNoSeries.RESET;
            LclNoSeries.SETRANGE(Code, LclItmJrnlBatch."No. Series");
            IF LclNoSeries.FIND('-') THEN BEGIN
                LclNoSeriesLine.RESET;
                LclNoSeriesLine.SETRANGE("Series Code", LclNoSeries.Code);
                LclNoSeriesLine.SETFILTER("Starting Date", '%1..%2', 0D, TODAY);
                IF LclNoSeriesLine.FIND('+') THEN BEGIN
                    IF (LclNoSeriesLine."Last No. Used" <> '') THEN
                        EXIT(INCSTR(LclNoSeriesLine."Last No. Used"))
                    ELSE
                        EXIT(LclNoSeriesLine."Starting No.");
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure getItmJrnlDocNo(): Code[20]
    var
        LclNoSeries: Record "308";
        LclNoSeriesLine: Record "309";
        LclItmJrnlBatch: Record "233";
    begin
        //Retrieving Document No. from No. Series Line table with filter from Item Journal Batch - No. Series assigned.
        LclItmJrnlBatch.RESET;
        LclItmJrnlBatch.SETRANGE("Journal Template Name", getItmJrnlTemplate);
        LclItmJrnlBatch.SETRANGE(Name, getItmJrnlBatch);
        IF LclItmJrnlBatch.FIND('-') THEN BEGIN
            LclNoSeries.RESET;
            LclNoSeries.SETRANGE(Code, LclItmJrnlBatch."No. Series");
            IF LclNoSeries.FIND('-') THEN BEGIN
                LclNoSeriesLine.RESET;
                LclNoSeriesLine.SETRANGE("Series Code", LclNoSeries.Code);
                LclNoSeriesLine.SETFILTER("Starting Date", '%1..%2', 0D, TODAY);
                IF LclNoSeriesLine.FIND('+') THEN BEGIN
                    IF (LclNoSeriesLine."Last No. Used" <> '') THEN
                        EXIT(INCSTR(LclNoSeriesLine."Last No. Used"))
                    ELSE
                        EXIT(LclNoSeriesLine."Starting No.");
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure getDfltLocation(): Code[10]
    begin
        //Retrieving Default Location Code for Procurement.
        GblUserSetup.GET(USERID);
        GblRespCntr.RESET;
        GblRespCntr.SETRANGE(Code, GblUserSetup."Default Responsibility Center");
        IF GblRespCntr.FIND('-') THEN
            EXIT(GblRespCntr."Location Code");
    end;

    [Scope('Internal')]
    procedure getDfltDim1Code(): Code[20]
    begin
        //Retrieving Default Global Dimension 1 Code for Procurement.
        GblUserSetup.GET(USERID);
        GblRespCntr.RESET;
        GblRespCntr.SETRANGE(Code, GblUserSetup."Default Responsibility Center");
        IF GblRespCntr.FIND('-') THEN
            EXIT(GblRespCntr."Global Dimension 1 Code");
    end;

    [Scope('Internal')]
    procedure getDfltDim2Code(): Code[20]
    begin
        //Retrieving Default Global Dimension 2 Code for Procurement.
        GblUserSetup.GET(USERID);
        GblRespCntr.RESET;
        GblRespCntr.SETRANGE(Code, GblUserSetup."Default Responsibility Center");
        IF GblRespCntr.FIND('-') THEN
            EXIT(GblRespCntr."Global Dimension 2 Code");
    end;

    [Scope('Internal')]
    procedure postItmRclsJrnl(PrmItmRclsJrnlLine: Record "83")
    var
        LclItmJrnlPostBatch: Codeunit "23";
    begin
        //Setting filter on Item Journal Line and posting Journal for Item Reclassification.
        LclItmJrnlPostBatch.RUN(PrmItmRclsJrnlLine);
    end;

    [Scope('Internal')]
    procedure postItmJrnl(PrmItmJrnlLine: Record "83")
    var
        LclItmJrnlPostBatch: Codeunit "23";
    begin
        //Setting filter on Item Journal Line and posting Journal for Item Journal.
        LclItmJrnlPostBatch.RUN(PrmItmJrnlLine);
    end;

    [Scope('Internal')]
    procedure showMessage()
    var
        Text33019810: Label 'Posted successfully.';
    begin
        MESSAGE(Text33019810);
    end;
}

