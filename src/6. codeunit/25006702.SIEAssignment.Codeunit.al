codeunit 25006702 "SIE Assignment"
{
    // 08.05.2013 EDMS P8
    //   * FIX new created line (when more than one line with the same item) should not correct existing reservation
    // 
    // 05.03.2013 EDMS P8
    //   * fix - now will not bring strmenu if automated
    // 
    // 31.03.2009 Karlo
    //   *New function AutoAsign


    trigger OnRun()
    begin
    end;

    var
        SIESetup: Record "25006701";
        ServLine: Record "25006146";
        ItemJnlLineTmp: Record "83" temporary;
        LookUpMgt: Codeunit "25006003";
        Text001: Label 'There is nothing to assign. %1 in %2';
        Text002: Label 'You cannot %1 more than %2 units in %3 = %4.';
        PutInTakeOut: Codeunit "25006010";
        NextLine: Integer;
        SrcType: Option Service,Sale;
        TrnsfrType: Option " ","Take-out","Put-in";
        Text003: Label 'Cannot find default bin.';
        Text004: Label 'assign';
        Text005: Label 'unassign';
        Text006: Label 'Do you want to post the assignment lines?';
        Text007: Label 'The assignment lines were successfully posted.';
        Text009: Label 'Do you want to post the assignment cancelling line?';
        Text010: Label 'The unassignment line was successfully posted.';
        Text012: Label 'Qty. to Assign is 0. Are you sure you want to take-out all Qty. Assigned?';
        Text013: Label 'You can''t transfer this type of lines.';
        Text014: Label 'Do you want to join item %2 assignment line %1 with order line nr. %3?';
        Text015: Label 'There is nothing to transfer.';

    [Scope('Internal')]
    procedure InsertAssgnt(SIEAssgnt: Record "25006706"; SIELedgEntry: Record "25006703"; var NextLineNo: Integer)
    var
        SIEAssgnt2: Record "25006706";
    begin
        NextLineNo := NextLineNo + 10000;

        SIEAssgnt2.INIT;
        SIEAssgnt2."Applies-to Type" := SIEAssgnt."Applies-to Type";
        SIEAssgnt2."Applies-to Doc. Type" := SIEAssgnt."Applies-to Doc. Type";
        SIEAssgnt2."Applies-to Doc. No." := SIEAssgnt."Applies-to Doc. No.";
        SIEAssgnt2."Applies-to Doc. Line No." := SIEAssgnt."Applies-to Doc. Line No.";
        SIEAssgnt2."Line No." := NextLineNo;
        SIEAssgnt2."Entry No." := SIELedgEntry."Entry No.";
        SIELedgEntry.CALCFIELDS("Qty. to Assign", "Qty. Assigned");
        SIEAssgnt2."Qty. to Assign" := SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned" - SIELedgEntry."Qty. to Assign";
        SIEAssgnt2.VALIDATE("Item No.", SIELedgEntry."Code20 2");
        SIEAssgnt2.Description := SIELedgEntry.Description;
        SIEAssgnt2."Unit Cost" := SIEAssgnt."Unit Cost";
        SIEAssgnt2."Assignment Date" := WORKDATE;
        SIEAssgnt2.INSERT;
    end;

    [Scope('Internal')]
    procedure SuggestAssgnt(FilterSIEAssgnt: Record "25006706")
    var
        SIELedgEntry: Record "25006703";
        ByItem: Code[20];
        ByDocNo: Code[20];
        SIEObject: Record "25006707";
        SIEAssgnt2: Record "25006706";
        ItemDesc: Text[30];
        SIESystem: Code[10];
    begin
        //Here is possible to select sie system

        SIESystem := SelectSIESytem;
        IF SIESystem = '' THEN EXIT;

        IF NOT FilterSIEAssgnt.RECORDLEVELLOCKING THEN
            FilterSIEAssgnt.LOCKTABLE(TRUE, TRUE);

        SIEAssgnt2.SETRANGE("Applies-to Type", "Applies-to Type");
        SIEAssgnt2.SETRANGE("Applies-to Doc. Type", "Applies-to Doc. Type");
        SIEAssgnt2.SETRANGE("Applies-to Doc. No.", "Applies-to Doc. No.");
        SIEAssgnt2.SETRANGE("Applies-to Doc. Line No.", "Applies-to Doc. Line No.");
        SIEAssgnt2.SETRANGE(Corrected, FALSE);
        ByDocNo := "Applies-to Doc. No.";
        TruncDocNo(ByDocNo);
        CASE "Applies-to Type" OF
            DATABASE::"Service Line EDMS":
                IF "Applies-to Doc. Line No." <> 0 THEN
                    ByItem := FilterSIEAssgnt."Item No.";
        END;
        SIELedgEntry.RESET;
        SIELedgEntry.SETCURRENTKEY("External Document No.", "Code20 2");
        SIELedgEntry.SETRANGE("SIE No.", SIESystem);
        IF ByDocNo <> '' THEN SIELedgEntry.SETRANGE("External Document No.", ByDocNo);
        IF ByItem <> '' THEN SIELedgEntry.SETRANGE("Code20 2", ByItem);
        IF SIELedgEntry.FINDFIRST THEN
            REPEAT
                NextLine := GetNextLineNo2(SIELedgEntry."Entry No.", FilterSIEAssgnt."Line No.");
                SIEAssgnt2.SETRANGE("Entry No.", SIELedgEntry."Entry No.");
                SIELedgEntry.CALCFIELDS("Qty. Assigned");
                IF (NOT SIEAssgnt2.FINDFIRST) AND (SIELedgEntry.Quantity - "Qty. Assigned" > 0) THEN
                    InsertAssgnt(FilterSIEAssgnt, SIELedgEntry, NextLine);
            UNTIL SIELedgEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SetSIEFilter(FilterAssgnt: Record "25006706"; var SIEAssgnt: Record "25006706")
    begin
        SIEAssgnt.RESET;
        SIEAssgnt.SETCURRENTKEY("Applies-to Type", "Applies-to Doc. Type",
          "Applies-to Doc. No.", "Applies-to Doc. Line No.", "Line No.");
        SIEAssgnt.SETRANGE("Applies-to Type", FilterAssgnt."Applies-to Type");
        SIEAssgnt.SETRANGE("Applies-to Doc. Type", FilterAssgnt."Applies-to Doc. Type");
        SIEAssgnt.SETRANGE("Applies-to Doc. No.", FilterAssgnt."Applies-to Doc. No.");
        IF FilterAssgnt."Applies-to Doc. Line No." <> 0 THEN
            SIEAssgnt.SETRANGE("Applies-to Doc. Line No.", FilterAssgnt."Applies-to Doc. Line No.");
        SIEAssgnt.SETRANGE(Type, SIEAssgnt.Type::Main);
    end;

    [Scope('Internal')]
    procedure PostAssignment(FilterSIEAssgnt: Record "25006706"; RunModeFlags: Integer)
    var
        SIEAssgnt: Record "25006706";
        SIEAssgnt2: Record "25006706";
        SIELedgEntry: Record "25006703";
        NextDocLineNo: Integer;
        JnlNewLineNoIN: Integer;
        JnlNewLineNoOUT: Integer;
        Qty: Decimal;
        FoundLineNo: Integer;
        FlagsArray: array[16] of Boolean;
    begin
        //RunModeFlags IF 0 MEANS not to run TransferAll
        AdjustFlagsToArray(RunModeFlags, FlagsArray);
        SIESetup.GET;
        IF GUIALLOWED THEN //!
            IF NOT CONFIRM(Text006, FALSE) THEN
                EXIT;

        SetSIEFilter(FilterSIEAssgnt, SIEAssgnt);
        SIEAssgnt.SETFILTER("Qty. to Assign", '<>0');
        IF NOT SIEAssgnt.FINDFIRST THEN BEGIN
            IF GUIALLOWED THEN
                MESSAGE(Text001, SIEAssgnt."Applies-to Doc. No.", SIEAssgnt.TABLECAPTION);
            EXIT;
        END;

        SIEAssgnt.FINDFIRST;
        REPEAT
            SIEAssgnt2.GET(SIEAssgnt."Entry No.", SIEAssgnt."Line No.");
            SIELedgEntry.GET(SIEAssgnt."Entry No.");
            SIELedgEntry.CALCFIELDS("Qty. Assigned");
            IF SIEAssgnt."Qty. to Assign" > (SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned") THEN
                ERROR(Text002, Text004, SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned",
                  SIEAssgnt.FIELDCAPTION("Line No."), SIEAssgnt."Line No.");

            IF "Applies-to Doc. Line No." = 0 THEN
                IF FindSIEAppliedLine(SIEAssgnt2, FoundLineNo) THEN
                    IF GUIALLOWED THEN //!
                        IF CONFIRM(Text014, TRUE, SIEAssgnt2."Line No.", SIEAssgnt2."Item No.", FoundLineNo) THEN
                            SIEAssgnt2."Applies-to Doc. Line No." := FoundLineNo
                        ELSE
                            CreateDocLine(SIEAssgnt2, NextDocLineNo)
                    ELSE
                        CreateDocLine(SIEAssgnt2, NextDocLineNo) //05.03.2013 EDMS P8
                                                                 //SIEAssgnt2."Applies-to Doc. Line No." := FoundLineNo //!
                ELSE
                    CreateDocLine(SIEAssgnt2, NextDocLineNo)
            // 21.12.2012 EDMS P8 - is not working for now - qty do not updates ???
            //CreateDocLine(SIEAssgnt2,NextDocLineNo)
            ELSE
                NextDocLineNo := SIEAssgnt2."Applies-to Doc. Line No.";

            Qty := SIEAssgnt."Qty. to Assign";
            SIEAssgnt2."Qty. to Assign" := 0;
            SIEAssgnt2.MODIFY;

            SIEAssgnt2."Appl. To Entry" := SIEAssgnt."Entry No.";
            SIEAssgnt2."Appl. To Line No." := SIEAssgnt."Line No.";
            NextLine := GetNextLineNo2(SIELedgEntry."Entry No.", SIEAssgnt."Line No.");
            SIEAssgnt2."Line No." := NextLine + 10000;

            SIEAssgnt2."Qty. Assigned Det." := Qty;
            SIEAssgnt2.Type := SIEAssgnt.Type::Detail;
            SIEAssgnt2.INSERT;
        UNTIL SIEAssgnt.NEXT = 0;

        DistributeTransfer(FilterSIEAssgnt);
        IF SIESetup."Automatic PutInTakeOut" THEN
            IF FlagsArray[1] THEN
                TransferAll(FilterSIEAssgnt);

        IF GUIALLOWED THEN
            MESSAGE(Text007);
    end;

    [Scope('Internal')]
    procedure CreateDocLine(var NewSIEAssgnt: Record "25006706"; var NextLineNo: Integer)
    begin
        CASE "Applies-to Type" OF
            DATABASE::"Service Line EDMS":
                BEGIN
                    IF NextLineNo = 0 THEN BEGIN
                        ServLine.RESET;
                        ServLine.SETRANGE("Document Type", "Applies-to Doc. Type");
                        ServLine.SETRANGE("Document No.", "Applies-to Doc. No.");
                        IF ServLine.FINDLAST THEN
                            NextLineNo := ServLine."Line No." + 10000
                        ELSE
                            NextLineNo := 10000;
                    END ELSE
                        NextLineNo := NextLineNo + 10000;
                    ServLine.INIT;
                    ServLine."Document Type" := NewSIEAssgnt."Applies-to Doc. Type";
                    ServLine."Document No." := NewSIEAssgnt."Applies-to Doc. No.";
                    ServLine."Line No." := NextLineNo;
                    ServLine.INSERT(TRUE);  //08.05.2013 EDMS P8
                    ServLine.VALIDATE(Type, ServLine.Type::Item);
                    ServLine.VALIDATE("No.", NewSIEAssgnt."Item No.");
                    ServLine.VALIDATE(Quantity, NewSIEAssgnt."Qty. to Assign");
                    ServLine.MODIFY(TRUE);  //08.05.2013 EDMS P8
                    "Applies-to Doc. Line No." := NextLineNo;
                    NewSIEAssgnt.MODIFY
                END
        END
    end;

    [Scope('Internal')]
    procedure AddUnassignedTran(FilterSIEAssgnt: Record "25006706")
    var
        SIELedgEntry: Record "25006703";
        SIELedgEntry2: Record "25006703" temporary;
        SIEAssgnt: Record "25006706";
        SIESystem: Code[10];
    begin
        SIESystem := SelectSIESytem;
        IF SIESystem = '' THEN EXIT;

        IF FilterSIEAssgnt."Applies-to Doc. Line No." <> 0 THEN
            SIELedgEntry.SETRANGE("Code20 2", FilterSIEAssgnt."Item No.");
        SIELedgEntry.SETRANGE("SIE No.", SIESystem);
        IF SIELedgEntry.FINDFIRST THEN
            REPEAT
                SIELedgEntry.CALCFIELDS("Qty. Assigned");
                IF SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned" > 0 THEN BEGIN
                    SIELedgEntry2.TRANSFERFIELDS(SIELedgEntry);
                    SIELedgEntry2.INSERT
                END
            UNTIL SIELedgEntry.NEXT = 0;
        IF LookUpSIETrans(SIELedgEntry2) THEN BEGIN
            NextLine := GetNextLineNo2(SIELedgEntry2."Entry No.", FilterSIEAssgnt."Line No.");
            WITH SIEAssgnt DO BEGIN
                SIEAssgnt.SETRANGE("Applies-to Type", FilterSIEAssgnt."Applies-to Type");
                SIEAssgnt.SETRANGE("Applies-to Doc. Type", FilterSIEAssgnt."Applies-to Doc. Type");
                SIEAssgnt.SETRANGE("Applies-to Doc. No.", FilterSIEAssgnt."Applies-to Doc. No.");
                SIEAssgnt.SETRANGE(Corrected, FALSE);
                SIEAssgnt.SETRANGE(Type, SIEAssgnt.Type::Main);
                SIEAssgnt.SETRANGE("Entry No.", SIELedgEntry2."Entry No.");
                IF NOT SIEAssgnt.FINDFIRST THEN
                    InsertAssgnt(FilterSIEAssgnt, SIELedgEntry2, NextLine)
            END
        END
    end;

    [Scope('Internal')]
    procedure LookUpSIETrans(var SIELedgEntry: Record "25006703"): Boolean
    var
        SIELedgerEntries: Page "25006756";
    begin
        CLEAR(SIELedgerEntries);
        SIELedgerEntries.SETTABLEVIEW(SIELedgEntry);
        SIELedgerEntries.LOOKUPMODE(TRUE);
        IF PAGE.RUNMODAL(PAGE::"SIE Ledger Entries", SIELedgEntry) = ACTION::LookupOK THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure PostUnAssignment(var SIEAssgnt: Record "25006706"; Auto: Boolean)
    var
        SrvLine: Record "25006146" temporary;
        SlsLine: Record "37" temporary;
        SIELedgEntry: Record "25006703";
        SIEAssgnt2: Record "25006706";
        SIEAssgnt3: Record "25006706";
        JnlNewLineNo: Integer;
        Qty: Decimal;
    begin
        SIESetup.GET;
        IF NOT Auto THEN BEGIN
            IF NOT GUIALLOWED THEN EXIT;
            IF NOT CONFIRM(Text009, FALSE) THEN
                EXIT;
        END;
        //Test block
        SIEAssgnt.CALCFIELDS("Doc. Qty. Assigned");
        IF "Doc. Qty. Assigned" = 0 THEN ERROR(Text001);

        IF SIEAssgnt."Qty. to Assign" = 0 THEN BEGIN
            IF NOT Auto THEN BEGIN
                IF NOT GUIALLOWED THEN EXIT;
                IF NOT CONFIRM(Text012, TRUE) THEN EXIT;
            END;
            Qty := "Doc. Qty. Assigned";
            Corrected := TRUE;
        END ELSE BEGIN
            IF SIEAssgnt."Qty. to Assign" > "Doc. Qty. Assigned" THEN
                ERROR(Text002, Text005, SIEAssgnt."Qty. Assigned", SIEAssgnt.FIELDCAPTION("Line No."), SIEAssgnt."Line No.")
            ELSE
                IF SIEAssgnt."Qty. to Assign" = "Doc. Qty. Assigned" THEN Corrected := TRUE;
            Qty := SIEAssgnt."Qty. to Assign";
            SIEAssgnt."Qty. to Assign" := 0;
        END;
        SIEAssgnt.MODIFY;
        IF Corrected THEN BEGIN
            SIEAssgnt3.SETRANGE("Entry No.", SIEAssgnt."Entry No.");
            SIEAssgnt3.SETRANGE(Type, SIEAssgnt.Type::Detail);
            SIEAssgnt3.SETRANGE("Applies-to Type", "Applies-to Type");
            SIEAssgnt3.SETRANGE("Applies-to Doc. Type", SIEAssgnt."Applies-to Doc. Type");
            SIEAssgnt3.SETRANGE("Applies-to Doc. No.", SIEAssgnt."Applies-to Doc. No.");
            SIEAssgnt3.MODIFYALL(Corrected, TRUE);
        END;

        SIEAssgnt2.COPY(SIEAssgnt);

        SIELedgEntry.GET(SIEAssgnt."Entry No.");

        SIEAssgnt."Qty. Assigned Det." := -Qty;

        "Appl. To Entry" := SIEAssgnt."Entry No.";
        "Appl. To Line No." := SIEAssgnt."Line No.";
        SIEAssgnt.Type := SIEAssgnt.Type::Detail;

        NextLine := GetNextLineNo2(SIELedgEntry."Entry No.", SIEAssgnt."Line No.");
        SIEAssgnt."Line No." := NextLine + 10000;

        SIEAssgnt.INSERT;

        DistributeTransfer(SIEAssgnt);
        IF SIESetup."Automatic PutInTakeOut" AND NOT Auto THEN
            TransferAll(SIEAssgnt);
        IF NOT Auto THEN
            IF GUIALLOWED THEN
                MESSAGE(Text010)
    end;

    [Scope('Internal')]
    procedure SelectSIESytem(): Code[10]
    var
        SpecInvtEquip: Record "25006700";
        Selection: Integer;
        SIESystems: Text[500];
        CommaPosition: Integer;
        CurrExpr: Code[10];
        i: Integer;
        RepeatedCount: Integer;
    begin
        SIESetup.GET;

        SpecInvtEquip.RESET;
        SpecInvtEquip.SETRANGE(Active, TRUE);
        IF SpecInvtEquip.FINDFIRST THEN BEGIN
            SIESystems := SpecInvtEquip."No.";
            WHILE SpecInvtEquip.NEXT <> 0 DO BEGIN
                SIESystems := SIESystems + ',' + SpecInvtEquip."No.";
            END
        END;

        CommaPosition := STRPOS(SIESystems, ',');
        IF (CommaPosition > 0) THEN BEGIN
            //05.03.2013 EDMS P8 >>
            IF GUIALLOWED THEN BEGIN
                IF (SIESetup."Default SIE Sys" > 0) THEN
                    Selection := STRMENU(SIESystems, SIESetup."Default SIE Sys")
                ELSE
                    Selection := STRMENU(SIESystems, 1);
            END ELSE BEGIN
                IF (SIESetup."Default SIE Sys" > 0) THEN BEGIN
                    Selection := SIESetup."Default SIE Sys";
                END ELSE BEGIN
                    Selection := 1;
                    SIESetup."Default SIE Sys" := Selection;
                    SIESetup.MODIFY;
                END;
            END;
            IF Selection = 0 THEN
                EXIT;
            //05.03.2013 EDMS P8 <<
            //27.03.2013 EDMS P8 >>
            IF SpecInvtEquip.FINDFIRST THEN;
            REPEAT
                Selection -= 1;
                IF Selection > 0 THEN
                    SpecInvtEquip.NEXT;
            UNTIL Selection <= 0;
            //27.03.2013 EDMS P8 <<
            CurrExpr := SpecInvtEquip."No.";
            EXIT(CurrExpr)
        END ELSE
            EXIT(SIESystems);
    end;

    [Scope('Internal')]
    procedure MoveAssgntToPostedDocLine(FromApplType: Integer; FromDocType: Option quote,"order",invoice; FromDocNo: Code[20]; FromLineNo: Integer; ToApplType: Integer; ToDocType: Option quote,"order",invoice; ToDocNo: Code[20]; ToLineNo: Integer)
    var
        SIEAssgnt: Record "25006706";
        SIEAssgnt2: Record "25006706";
        NextLineNo: Integer;
        CurrEntry: Integer;
    begin
        SIEAssgnt.RESET;
        SIEAssgnt.SETRANGE("Applies-to Type", FromApplType);
        SIEAssgnt.SETRANGE("Applies-to Doc. Type", FromDocType);
        SIEAssgnt.SETRANGE("Applies-to Doc. No.", FromDocNo);
        IF FromLineNo <> 0 THEN
            SIEAssgnt.SETRANGE("Applies-to Doc. Line No.", FromLineNo);
        IF SIEAssgnt.FINDFIRST THEN BEGIN
            REPEAT
                IF CurrEntry <> SIEAssgnt."Entry No." THEN BEGIN
                    NextLineNo := GetNextLineNo2(SIEAssgnt."Entry No.", SIEAssgnt."Line No.");
                    CurrEntry := SIEAssgnt."Entry No."
                END;
                NextLineNo += 10000;
                SIEAssgnt2.INIT;
                SIEAssgnt2.TRANSFERFIELDS(SIEAssgnt);
                SIEAssgnt2."Applies-to Type" := ToApplType;
                SIEAssgnt2."Applies-to Doc. Type" := ToDocType;
                SIEAssgnt2."Applies-to Doc. No." := ToDocNo;
                SIEAssgnt2."Line No." := NextLineNo;
                IF ToLineNo <> 0 THEN
                    SIEAssgnt2."Applies-to Doc. Line No." := ToLineNo;
                SIEAssgnt2.INSERT
            UNTIL SIEAssgnt.NEXT = 0;
            SIEAssgnt.DELETEALL
        END
    end;

    [Scope('Internal')]
    procedure GetNextLineNo2(EntryNo: Integer; LineNo: Integer): Integer
    var
        SIEAssgnt: Record "25006706";
    begin
        SIEAssgnt.RESET;
        SIEAssgnt.SETRANGE("Entry No.", EntryNo);
        IF SIEAssgnt.FINDLAST THEN EXIT(SIEAssgnt."Line No.") ELSE EXIT(LineNo)
    end;

    [Scope('Internal')]
    procedure InitTransfer(FilterSIEAssgnt: Record "25006706"; TrsfrType: Option " ","Take-out","Put-in"; var JnlNewLine: Integer)
    var
        SrvLine: Record "25006146" temporary;
        SlsLine: Record "37" temporary;
    begin
        CLEAR(ItemJnlLineTmp);
        CASE "Applies-to Type" OF
            DATABASE::"Service Line EDMS":
                SrcType := SrcType::Service;
            DATABASE::"Sales Line":
                SrcType := SrcType::Sale;
            ELSE
                ERROR(Text013);
        END;

        SrvLine.SETRANGE("Document No.", "Applies-to Doc. No.");
        SrvLine.SETRANGE("Line No.", "Applies-to Doc. Line No.");
        SlsLine.SETRANGE("Document No.", "Applies-to Doc. No.");
        SlsLine.SETRANGE("Line No.", "Applies-to Doc. Line No.");

        CLEAR(PutInTakeOut);
        //PutInTakeOut.Initialize(ItemJnlLineTmp,SrcType,TrsfrType,1,"Applies-to Doc. No.",0,SrvLine,SlsLine);
        //JnlNewLine := PutInTakeOut.LinkTransferWithService(ItemJnlLineTmp);
    end;

    [Scope('Internal')]
    procedure DistributeTransfer(FilterSIEAssgnt: Record "25006706") Result: Boolean
    var
        SIEAssgnt: Record "25006706";
        SIEAssgnt2: Record "25006706";
        CurrLineNo: Integer;
        QtyOnLine: Decimal;
        QtyToBe: Decimal;
    begin
        Result := FALSE;
        SetSIEFilter(FilterSIEAssgnt, SIEAssgnt);
        SIEAssgnt.MODIFYALL("Qty. to Transfer", 0);
        SIEAssgnt2.COPY(SIEAssgnt);

        IF SIEAssgnt.FINDFIRST THEN
            REPEAT
                IF "Applies-to Doc. Line No." = 0 THEN BEGIN   //New line - all clear to understand
                    IF SIEAssgnt."Qty. to Assign" <> 0 THEN BEGIN
                        "Qty. to Transfer" := SIEAssgnt."Qty. to Assign";
                        SIEAssgnt.MODIFY;
                        Result := TRUE;
                    END;
                END ELSE BEGIN
                    IF CurrLineNo <> "Applies-to Doc. Line No." THEN BEGIN  //Next Line No - calculate sums for order line.
                        CurrLineNo := "Applies-to Doc. Line No.";
                        SIEAssgnt2.SETRANGE("Applies-to Doc. Line No.", "Applies-to Doc. Line No.");
                        SIEAssgnt2.CALCSUMS("Qty. to Assign");
                        QtyToBe := SIEAssgnt2."Qty. to Assign";
                        SIEAssgnt2.SETRANGE(Type, SIEAssgnt.Type::Detail);
                        SIEAssgnt2.CALCSUMS("Qty. Assigned Det.");
                        QtyToBe += SIEAssgnt2."Qty. Assigned Det.";
                        SIEAssgnt2.SETRANGE(Type, SIEAssgnt.Type::Main);
                        CASE "Applies-to Type" OF
                            DATABASE::"Service Line EDMS":
                                BEGIN
                                    ServLine.GET("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
                                    QtyOnLine := ServLine.CalcTransferedQuantity;
                                END
                            ELSE
                                EXIT(FALSE)
                        END;
                        QtyToBe -= QtyOnLine;
                        Result := Result OR (QtyToBe <> 0);
                    END;
                    SIEAssgnt.CALCFIELDS("Qty. Assigned");                             //Split sums by assignment lines
                    IF QtyToBe <> 0 THEN
                        IF ABS(QtyToBe) > SIEAssgnt."Qty. to Assign" + SIEAssgnt."Qty. Assigned" THEN BEGIN
                            "Qty. to Transfer" := SIEAssgnt."Qty. to Assign" + SIEAssgnt."Qty. Assigned";
                            IF QtyToBe < 0 THEN "Qty. to Transfer" := "Qty. to Transfer" * -1;
                            QtyToBe -= "Qty. to Transfer";
                        END ELSE BEGIN
                            "Qty. to Transfer" := QtyToBe;
                            QtyToBe := 0;
                        END;
                    IF (SIEAssgnt."Qty. Assigned" = 0) AND ("Qty. to Transfer" = 0) AND (SIEAssgnt."Qty. to Assign" = 0) THEN
                        Corrected := TRUE;
                    SIEAssgnt.MODIFY
                END
            UNTIL SIEAssgnt.NEXT = 0;
        IF QtyToBe <> 0 THEN BEGIN
            Corrected := FALSE;
            "Qty. to Transfer" += QtyToBe;
            SIEAssgnt.MODIFY
        END
        EXIT(Result);
    end;

    [Scope('Internal')]
    procedure TransferAll(FilterSIEAssgnt: Record "25006706")
    var
        SIEAssgnt: Record "25006706";
        SIELedgEntry: Record "25006703";
        ServiceHeader: Record "25006145";
        JnlLine: Integer;
        ServiceTransferMgt: Codeunit "25006010";
        isFound: Boolean;
    begin
        isFound := FALSE;
        IF DistributeTransfer(FilterSIEAssgnt) THEN BEGIN
            SetSIEFilter(FilterSIEAssgnt, SIEAssgnt);
            SIEAssgnt.SETFILTER("Applies-to Doc. Line No.", '<>0');
            SIEAssgnt.SETFILTER("Qty. to Transfer", '>0');
            IF SIEAssgnt.FINDFIRST THEN BEGIN
                isFound := TRUE;
                ServiceHeader.GET(SIEAssgnt."Applies-to Doc. Type", SIEAssgnt."Applies-to Doc. No.");
                IF NOT GUIALLOWED THEN
                    MESSAGE('NASMSG: is going to ServiceTransferMgt.CreateTransferOrderBySIEAssign');
                ServiceTransferMgt.CreateTransferOrderBySIEAssign(ServiceHeader, SIEAssgnt, TRUE, 0);
                COMMIT;
                IF NOT GUIALLOWED THEN
                    MESSAGE('NASMSG: is going to PostTransferAll');
                PostTransferAll(SIEAssgnt);
            END;
            SIEAssgnt.SETFILTER("Qty. to Transfer", '<0');
            IF SIEAssgnt.FINDFIRST THEN BEGIN
                isFound := TRUE;
                ServiceHeader.GET(SIEAssgnt."Applies-to Doc. Type", SIEAssgnt."Applies-to Doc. No.");
                IF NOT GUIALLOWED THEN
                    MESSAGE('NASMSG: is going to ServiceTransferMgt.CreateTransferOrderBySIEAssign for negativ');
                ServiceTransferMgt.CreateTransferOrderBySIEAssign(ServiceHeader, SIEAssgnt, FALSE, 0);
                COMMIT;
                IF NOT GUIALLOWED THEN
                    MESSAGE('NASMSG: is going to PostTransferAll for negativ');
                PostTransferAll(SIEAssgnt);
            END;

            DistributeTransfer(FilterSIEAssgnt);
        END;

        IF NOT isFound THEN
            IF GUIALLOWED THEN
                MESSAGE(Text015);
    end;

    [Scope('Internal')]
    procedure PostTransferAll(FilterSIEAssgnt: Record "25006706")
    var
        SIEAssgnt: Record "25006706";
        SIELedgEntry: Record "25006703";
        ServiceHeader: Record "25006145";
        JnlLine: Integer;
        ServiceTransferMgt: Codeunit "25006010";
    begin
        //IF DistributeTransfer(FilterSIEAssgnt) THEN
        SetSIEFilter(FilterSIEAssgnt, SIEAssgnt);
        SIEAssgnt.SETFILTER("Applies-to Doc. Line No.", '<>0');
        SIEAssgnt.SETFILTER("Qty. to Transfer", '<>0');
        IF SIEAssgnt.FINDFIRST THEN BEGIN
            IF ServiceHeader.GET(ServiceHeader."Document Type"::Order, SIEAssgnt."Applies-to Doc. No.") THEN
                ServiceTransferMgt.PostTransOrderHByServH(ServiceHeader, 0);
            //SETRANGE(Type);  // P8 ??? must be removed WHEN transfer post will be finished
            SIEAssgnt.MODIFYALL("Qty. to Transfer", 0);
        END;
    end;

    [Scope('Internal')]
    procedure TruncDocNo(var DocNo: Code[20])
    var
        TmpStr: Text[20];
    begin
        //WHILE (DocNo <> '') AND (DocNo[1] IN ['A'..'Z','0']) DO BEGIN
        //  DocNo := COPYSTR(DocNo,2,STRLEN(DocNo)-1);
        //END;
    end;

    [Scope('Internal')]
    procedure FindSIEAppliedLine(SIEAssgnt: Record "25006706"; var FoundLine: Integer): Boolean
    begin
        CASE "Applies-to Type" OF
            DATABASE::"Service Line EDMS":
                BEGIN
                    ServLine.RESET;
                    ServLine.SETCURRENTKEY(Type, "No.");
                    ServLine.SETRANGE("Document Type", "Applies-to Doc. Type");
                    ServLine.SETRANGE("Document No.", "Applies-to Doc. No.");
                    ServLine.SETRANGE(Type, ServLine.Type::Item);
                    ServLine.SETRANGE("No.", SIEAssgnt."Item No.");
                    IF ServLine.FINDLAST THEN BEGIN
                        FoundLine := ServLine."Line No.";
                        EXIT(TRUE)
                    END
                END
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure AddUnassignedTranSilent(FilterSIEAssgnt: Record "25006706"; EntryNo: Integer)
    var
        SIELedgEntry: Record "25006703";
        SIELedgEntry2: Record "25006703" temporary;
        SIEAssgnt: Record "25006706";
        SIESystem: Code[10];
    begin
        //05.03.2013 EDMS P8 >>
        SIELedgEntry.GET(EntryNo);
        SIESystem := SIELedgEntry."SIE No.";
        IF SIESystem = '' THEN
            SIESystem := SelectSIESytem;
        IF SIESystem = '' THEN EXIT;
        //05.03.2013 EDMS P8 <<

        SIELedgEntry.CALCFIELDS("Qty. Assigned");
        IF SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned" > 0 THEN BEGIN
            SIELedgEntry2.TRANSFERFIELDS(SIELedgEntry);
            SIELedgEntry2.INSERT
        END ELSE
            EXIT;


        NextLine := GetNextLineNo2(SIELedgEntry2."Entry No.", FilterSIEAssgnt."Line No.");

        SIEAssgnt.SETRANGE("Applies-to Type", FilterSIEAssgnt."Applies-to Type");
        SIEAssgnt.SETRANGE("Applies-to Doc. Type", FilterSIEAssgnt."Applies-to Doc. Type");
        SIEAssgnt.SETRANGE("Applies-to Doc. No.", FilterSIEAssgnt."Applies-to Doc. No.");
        SIEAssgnt.SETRANGE(Corrected, FALSE);
        SIEAssgnt.SETRANGE(Type, SIEAssgnt.Type::Main);
        SIEAssgnt.SETRANGE("Entry No.", SIELedgEntry2."Entry No.");
        IF NOT SIEAssgnt.FINDFIRST THEN
            InsertAssgnt(FilterSIEAssgnt, SIELedgEntry2, NextLine)
    end;

    [Scope('Internal')]
    procedure "--SMALL TECHN--"()
    begin
    end;

    [Scope('Internal')]
    procedure CutNextBit(var Flags: Integer) RetValue: Boolean
    begin
        RetValue := ((Flags MOD 2) > 0);
        Flags := Flags DIV 2;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure AdjustFlagsToArray(Flags: Integer; var ArrayEDMS: array[16] of Boolean)
    var
        i: Integer;
    begin
        FOR i := 1 TO 16 DO BEGIN
            ArrayEDMS[i] := CutNextBit(Flags);
        END;
    end;
}

