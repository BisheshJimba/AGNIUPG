codeunit 25006404 "Warranty Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Warranty Document Nr. %1 created.';

    [Scope('Internal')]
    procedure CreateWarrantyDocument(var PstdServiceOrderHeader: Record "25006149")
    var
        PstdServiceOrderLine: Record "25006150";
        SelectedRecord: Record "25006150";
        WarrantyPstdServiceLine: Page "25006410";
        Selected: Text[250];
        NewWarrantyHeader: Record "25006405";
        NewWarrantyLine: Record "25006406";
        PstdServLineNoFilter: Text[250];
        ExistingWarrantyDocumentLine: Record "25006406";
    begin
        PstdServiceOrderLine.RESET;
        PstdServiceOrderLine.SETRANGE("Document No.", PstdServiceOrderHeader."No.");
        IF PstdServiceOrderLine.FINDFIRST THEN
            REPEAT
                ExistingWarrantyDocumentLine.RESET;
                ExistingWarrantyDocumentLine.SETRANGE("Service Order No.", PstdServiceOrderLine."Document No.");
                ExistingWarrantyDocumentLine.SETRANGE("Service Order Line No.", PstdServiceOrderLine."Line No.");
                IF NOT ExistingWarrantyDocumentLine.FINDFIRST THEN
                    PstdServiceOrderLine.MARK(TRUE);
            UNTIL PstdServiceOrderLine.NEXT = 0;

        PstdServiceOrderLine.MARKEDONLY(TRUE);
        WarrantyPstdServiceLine.SETTABLEVIEW(PstdServiceOrderLine);
        WarrantyPstdServiceLine.LOOKUPMODE(TRUE);
        WarrantyPstdServiceLine.EDITABLE(FALSE);
        IF WarrantyPstdServiceLine.RUNMODAL = ACTION::LookupOK THEN BEGIN
            SelectedRecord := PstdServiceOrderLine;
            WarrantyPstdServiceLine.SetSelected(SelectedRecord);
            SelectedRecord.MARKEDONLY(TRUE);
            IF SelectedRecord.FINDFIRST THEN BEGIN
                CreateWarrantyHeader(NewWarrantyHeader);
                NewWarrantyHeader."Service Order No." := PstdServiceOrderHeader."No.";
                NewWarrantyHeader."Service Order Sequence No." := GetServWarrantyDocSequence(PstdServiceOrderHeader."No.");
                NewWarrantyHeader."Vehicle Serial No." := PstdServiceOrderHeader."Vehicle Serial No.";
                NewWarrantyHeader."Vehicle Registration No." := PstdServiceOrderHeader."Vehicle Registration No.";
                NewWarrantyHeader."Vehicle Status Code" := PstdServiceOrderHeader."Vehicle Status Code";
                NewWarrantyHeader."Vehicle Accounting Cycle No." := PstdServiceOrderHeader."Vehicle Accounting Cycle No.";
                NewWarrantyHeader.VIN := PstdServiceOrderHeader.VIN;
                NewWarrantyHeader."Make Code" := PstdServiceOrderHeader."Make Code";
                NewWarrantyHeader."Model Code" := PstdServiceOrderHeader."Model Code";
                NewWarrantyHeader."Model Commercial Name" := PstdServiceOrderHeader."Model Commercial Name";
                NewWarrantyHeader."Model Version No." := PstdServiceOrderHeader."Model Version No.";
                NewWarrantyHeader.MODIFY;
                REPEAT
                    CreateWarrantyLine(NewWarrantyHeader, NewWarrantyLine);
                    NewWarrantyLine."Service Order No." := SelectedRecord."Document No.";
                    NewWarrantyLine."Service Order Line No." := SelectedRecord."Line No.";
                    NewWarrantyLine.VALIDATE(Type, SelectedRecord.Type);
                    NewWarrantyLine.VALIDATE("No.", SelectedRecord."No.");
                    NewWarrantyLine.VALIDATE(Description, SelectedRecord.Description);
                    NewWarrantyLine.VALIDATE("Unit Price", SelectedRecord."Unit Price");
                    NewWarrantyLine.VALIDATE(Quantity, SelectedRecord.Quantity);
                    NewWarrantyLine.VALIDATE("Standard Time", SelectedRecord."Standard Time");
                    NewWarrantyLine.VALIDATE("Make Code", SelectedRecord."Make Code");
                    NewWarrantyLine.MODIFY;
                UNTIL SelectedRecord.NEXT = 0;
                IF NewWarrantyHeader."No." <> '' THEN
                    MESSAGE(Text001, NewWarrantyHeader."No.");
            END;
        END;
    end;

    [Scope('Internal')]
    procedure CreateWarrantyHeader(var WarrantyDocumentHeader: Record "25006405")
    begin
        CLEAR(WarrantyDocumentHeader);
        WarrantyDocumentHeader.RESET;
        WarrantyDocumentHeader.INIT;
        WarrantyDocumentHeader.INSERT(TRUE);
    end;

    [Scope('Internal')]
    procedure CreateWarrantyLine(WarrantyDocumentHeader: Record "25006405"; var WarrantyDocumentLine: Record "25006406")
    var
        LineNo: Integer;
    begin
        WarrantyDocumentLine.RESET;
        WarrantyDocumentLine.SETRANGE("Document No.", WarrantyDocumentHeader."No.");
        IF WarrantyDocumentLine.FINDLAST THEN
            LineNo := WarrantyDocumentLine."Line No.";

        WarrantyDocumentLine.RESET;
        WarrantyDocumentLine.INIT;
        WarrantyDocumentLine."Document No." := WarrantyDocumentHeader."No.";
        WarrantyDocumentLine."Line No." := LineNo + 10000;
        WarrantyDocumentLine.INSERT(TRUE);
    end;

    local procedure GetServWarrantyDocSequence(ServiceDocumentNo: Code[20]) SequenceNo: Integer
    var
        WarrantyDocumentHeader: Record "25006405";
    begin
        WarrantyDocumentHeader.RESET;
        WarrantyDocumentHeader.SETRANGE("Service Order No.", ServiceDocumentNo);
        IF WarrantyDocumentHeader.FINDLAST THEN
            SequenceNo := WarrantyDocumentHeader."Service Order Sequence No." + 1
        ELSE
            SequenceNo := 1;
    end;

    local procedure GetPstdServLineNoFilter(ServiceDocumentNo: Code[20]) LineNoFilter: Text[250]
    var
        WarrantyDocumentLine: Record "25006406";
    begin
        WarrantyDocumentLine.RESET;
        WarrantyDocumentLine.SETRANGE("Service Order No.", ServiceDocumentNo);
        IF WarrantyDocumentLine.FINDFIRST THEN
            REPEAT
                LineNoFilter += '<>' + FORMAT(WarrantyDocumentLine."Line No.") + '&';
            UNTIL WarrantyDocumentLine.NEXT = 0;

        IF LineNoFilter <> '' THEN
            LineNoFilter := DELCHR(LineNoFilter, '>', '&');
    end;
}

