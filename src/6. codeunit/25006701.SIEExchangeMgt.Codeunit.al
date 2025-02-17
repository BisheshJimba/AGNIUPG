codeunit 25006701 "SIE Exchange Mgt."
{

    trigger OnRun()
    var
        SIESetup: Record "25006701";
        XMLFile: File;
        XMLin: InStream;
    begin
        SIESetup.GET;

        IF EXISTS(SIESetup."File Name") THEN BEGIN
            XMLFile.OPEN(SIESetup."File Name");
            XMLFile.CREATEINSTREAM(XMLin);
            XMLPORT.IMPORT(XMLPORT::"SIE Import", XMLin);
            XMLFile.CLOSE;
            ERASE(SIESetup."File Name");
        END
    end;

    var
        SIE: Record "25006700";
        Descr: Text[50];
        Text000: Label 'SIE';
        Text001: Label 'Special Inventory Equip. Journal';
        Text002: Label 'Recurring';
        Text003: Label 'Recurring Spec. Invt. Equip. Journal';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';

    [Scope('Internal')]
    procedure CheckMandatoryFields(SIEJnl: Record "25006702"): Text[200]
    var
        AppMgt: Codeunit "1";
        RecRef: RecordRef;
        RecRef2: RecordRef;
        FldRef: FieldRef;
        i: Integer;
        k: Integer;
        Txt: Text[200];
    begin
        GetSIE(SIEJnl."SIE No.", Descr);
        RecRef.GETTABLE(SIEJnl);
        RecRef2.GETTABLE(SIE);
        FOR i := 0 TO 4 DO BEGIN
            FldRef := RecRef2.FIELD(SIE.FIELDNO("Mand.1 Field") + (i * 10));
            k := FldRef.VALUE;
            IF k <> 0 THEN BEGIN
                FldRef := RecRef.FIELD(k);
                IF IsEmptyFieldRef(FldRef) THEN
                    IF Txt = '' THEN
                        Txt := AppMgt.CaptionClassTranslate(GLOBALLANGUAGE, SIEJnl.GetCaption(FldRef.NUMBER))
                    ELSE
                        Txt := Txt + ',' + AppMgt.CaptionClassTranslate(GLOBALLANGUAGE, SIEJnl.GetCaption(FldRef.NUMBER))
            END;
        END;
        EXIT(Txt)
    end;

    [Scope('Internal')]
    procedure GetSIE(SIENo: Code[10]; var Descr: Text[50])
    begin
        IF SIE."No." <> SIENo THEN BEGIN
            Descr := '';
            IF SIENo <> '' THEN
                IF SIE.GET(SIENo) THEN
                    Descr := SIE.Description
        END
    end;

    [Scope('Internal')]
    procedure IsEmptyFieldRef(FRef: FieldRef): Boolean
    var
        Fld: Record "2000000041";
        intvar: Integer;
        txtvar: Text[20];
    begin
        EVALUATE(Fld.Type, FORMAT(FRef.TYPE));
        CASE Fld.Type OF
            Fld.Type::Code, Fld.Type::Text:
                BEGIN
                    txtvar := FRef.VALUE;
                    EXIT(txtvar = '');
                END;
            Fld.Type::Date:
                EXIT(VARIANT2DATE(FRef.VALUE) = 0D);
            Fld.Type::Integer, Fld.Type::Decimal:
                BEGIN
                    intvar := FRef.VALUE;
                    EXIT(intvar = 0);
                END;
            ELSE BEGIN
                Fld.GET(FRef.RECORD.NUMBER, FRef.NUMBER);
                Fld.FIELDERROR(Type);
            END
        END
    end;

    [Scope('Internal')]
    procedure TemplateSelection(FormID: Integer; RecurringJnl: Boolean; var SIEJnlLine: Record "25006702"; var JnlSelected: Boolean)
    var
        SIEJnlTemplate: Record "82";
    begin
        JnlSelected := TRUE;

        SIEJnlTemplate.RESET;
        SIEJnlTemplate.SETRANGE("Page ID", FormID);
        SIEJnlTemplate.SETRANGE(Recurring, RecurringJnl);

        CASE SIEJnlTemplate.COUNT OF
            0:
                BEGIN
                    SIEJnlTemplate.INIT;
                    SIEJnlTemplate.Recurring := RecurringJnl;
                    IF NOT RecurringJnl THEN BEGIN
                        SIEJnlTemplate.Name := Text000;
                        SIEJnlTemplate.Description := Text001;
                    END ELSE BEGIN
                        SIEJnlTemplate.Name := Text002;
                        SIEJnlTemplate.Description := Text003;
                    END;
                    SIEJnlTemplate.VALIDATE("Page ID");
                    SIEJnlTemplate.INSERT;
                    COMMIT;
                END;
            1:
                SIEJnlTemplate.FIND('-');
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, SIEJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            SIEJnlLine.FILTERGROUP := 2;
            SIEJnlLine.SETRANGE("Journal Template Name", SIEJnlTemplate.Name);
            SIEJnlLine.FILTERGROUP := 0;
        END;
    end;

    [Scope('Internal')]
    procedure OpenJournal(var CurrentJnlBatchName: Code[10]; var SIEJnlLine: Record "25006702")
    begin
        CheckTemplateName(SIEJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
        SIEJnlLine.FILTERGROUP := 2;
        SIEJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        SIEJnlLine.FILTERGROUP := 0;
    end;

    [Scope('Internal')]
    procedure CheckName(CurrentJnlBatchName: Code[10]; var SIEJnlLine: Record "25006702")
    var
        SIEJnlBatch: Record "233";
    begin
        SIEJnlBatch.GET(SIEJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
    end;

    [Scope('Internal')]
    procedure SetName(CurrentJnlBatchName: Code[10]; var SIEJnlLine: Record "25006702")
    begin
        SIEJnlLine.FILTERGROUP := 2;
        SIEJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        SIEJnlLine.FILTERGROUP := 0;
        IF SIEJnlLine.FIND('-') THEN;
    end;

    [Scope('Internal')]
    procedure LookupName(var CurrentJnlBatchName: Code[10]; var SIEJnlLine: Record "25006702"): Boolean
    var
        SIEJnlBatch: Record "233";
    begin
        COMMIT;
        SIEJnlBatch."Journal Template Name" := SIEJnlLine.GETRANGEMAX("Journal Template Name");
        SIEJnlBatch.Name := SIEJnlLine.GETRANGEMAX("Journal Batch Name");
        SIEJnlBatch.FILTERGROUP := 2;
        SIEJnlBatch.SETRANGE("Journal Template Name", SIEJnlBatch."Journal Template Name");
        SIEJnlBatch.FILTERGROUP := 0;
        IF PAGE.RUNMODAL(0, SIEJnlBatch) = ACTION::LookupOK THEN BEGIN
            CurrentJnlBatchName := SIEJnlBatch.Name;
            SetName(CurrentJnlBatchName, SIEJnlLine);
        END;
    end;

    local procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        SIEJnlBatch: Record "233";
    begin
        IF NOT SIEJnlBatch.GET(CurrentJnlTemplateName, CurrentJnlBatchName) THEN BEGIN
            SIEJnlBatch.SETRANGE("Journal Template Name", CurrentJnlTemplateName);
            IF SIEJnlBatch.ISEMPTY THEN BEGIN
                SIEJnlBatch.INIT;
                SIEJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                SIEJnlBatch.SetupNewBatch;
                SIEJnlBatch.Name := Text004;
                SIEJnlBatch.Description := Text005;
                SIEJnlBatch.INSERT(TRUE);
                COMMIT;
            END;
            CurrentJnlBatchName := SIEJnlBatch.Name;
        END;
    end;
}

