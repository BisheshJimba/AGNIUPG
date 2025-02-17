codeunit 25006305 VehicleOptJnlManagement
{
    Permissions = TableData 82 = imd,
                  TableData 233 = imd;

    trigger OnRun()
    begin
    end;

    var
        Text003: Label 'DEFAULT';
        Text004: Label 'Default Journal';
        codOldItemNo: Code[20];
        codOldNewItemNo: Code[20];

    [Scope('Internal')]
    procedure fTemplateSelection(var recVehoptJnlLine: Record "25006387")
    var
        recVehOptJnlTemplate: Record "25006385";
        bJnlSelected: Boolean;
    begin
        bJnlSelected := TRUE;

        recVehOptJnlTemplate.RESET;

        CASE recVehOptJnlTemplate.COUNT OF
            0:
                BEGIN
                    recVehOptJnlTemplate.INIT;
                    recVehOptJnlTemplate.VALIDATE("Form ID");
                    BEGIN
                        BEGIN
                            recVehOptJnlTemplate.Name := '';
                        END;
                    END;
                    recVehOptJnlTemplate.INSERT;
                    COMMIT;
                END;
            1:
                BEGIN
                    recVehOptJnlTemplate.FINDFIRST;
                END;
            ELSE
                bJnlSelected := PAGE.RUNMODAL(0, recVehOptJnlTemplate) = ACTION::LookupOK;
        END;
        IF bJnlSelected THEN BEGIN
            recVehoptJnlLine.FILTERGROUP := 2;
            recVehoptJnlLine.SETRANGE("Journal Template Name", recVehOptJnlTemplate.Name);
            recVehoptJnlLine.FILTERGROUP := 0;
            //PAGE.RUN(recVehOptJnlTemplate."Form ID",recVehOptJnlLine);
        END;
    end;

    [Scope('Internal')]
    procedure fOpenJnl(var codCurrentJnlBatchName: Code[10]; var recVehoptJnlLine: Record "25006387")
    begin
        fCheckTemplateName(recVehoptJnlLine.GETRANGEMAX("Journal Template Name"), codCurrentJnlBatchName);
        recVehoptJnlLine.FILTERGROUP := 2;
        recVehoptJnlLine.SETRANGE("Journal Batch Name", codCurrentJnlBatchName);
        recVehoptJnlLine.FILTERGROUP := 0;
    end;

    [Scope('Internal')]
    procedure fCheckTemplateName(codCurrentJnlTemplateName: Code[10]; var codCurrentJnlBatchName: Code[10])
    var
        recvehoptJnlBatch: Record "25006386";
    begin
        recvehoptJnlBatch.SETRANGE("Journal Template Name", codCurrentJnlTemplateName);
        IF NOT recvehoptJnlBatch.GET(codCurrentJnlTemplateName, codCurrentJnlBatchName) THEN BEGIN
            IF recvehoptJnlBatch.ISEMPTY THEN BEGIN
                recvehoptJnlBatch.INIT;
                recvehoptJnlBatch."Journal Template Name" := codCurrentJnlTemplateName;
                recvehoptJnlBatch.fSetupNewBatch;
                recvehoptJnlBatch.Name := Text003;
                recvehoptJnlBatch.Description := Text004;
                recvehoptJnlBatch.INSERT(TRUE);
                COMMIT;
            END;
            codCurrentJnlBatchName := recvehoptJnlBatch.Name
        END;
    end;

    [Scope('Internal')]
    procedure fCheckName(codCurrentJnlBatchName: Code[10]; var recVehOptJnlLine: Record "25006387")
    var
        recVehOptJnlBatch: Record "25006386";
    begin
        recVehOptJnlBatch.GET(recVehOptJnlLine.GETRANGEMAX("Journal Template Name"), codCurrentJnlBatchName);
    end;

    [Scope('Internal')]
    procedure fSetName(codCurrentJnlBatchName: Code[10]; var recVehOptJnlLine: Record "25006387")
    begin
        recVehOptJnlLine.FILTERGROUP := 2;
        recVehOptJnlLine.SETRANGE("Journal Batch Name", codCurrentJnlBatchName);
        recVehOptJnlLine.FILTERGROUP := 0;
        IF recVehOptJnlLine.FINDSET THEN;
    end;

    [Scope('Internal')]
    procedure fLookupName(var codCurrentJnlBatchName: Code[10]; var recVehOptJnlLine: Record "25006387"): Boolean
    var
        recVehOptJnlBatch: Record "25006386";
    begin
        COMMIT;
        recVehOptJnlBatch."Journal Template Name" := recVehOptJnlLine.GETRANGEMAX("Journal Template Name");
        recVehOptJnlBatch.Name := recVehOptJnlLine.GETRANGEMAX("Journal Batch Name");
        recVehOptJnlBatch.FILTERGROUP := 2;
        recVehOptJnlBatch.SETRANGE("Journal Template Name", recVehOptJnlBatch."Journal Template Name");
        recVehOptJnlBatch.FILTERGROUP := 0;
        IF PAGE.RUNMODAL(0, recVehOptJnlBatch) = ACTION::LookupOK THEN BEGIN
            codCurrentJnlBatchName := recVehOptJnlBatch.Name;
            fSetName(codCurrentJnlBatchName, recVehOptJnlLine);
        END;
    end;

    [Scope('Internal')]
    procedure fOnAfterInputItemNo(var txtText: Text[1024]): Text[1024]
    var
        recItem: Record "27";
        iNumber: Integer;
    begin
        IF txtText = '' THEN
            EXIT;

        IF EVALUATE(iNumber, txtText) THEN
            EXIT;

        recItem."No." := txtText;
        IF recItem.FINDFIRST THEN
            IF COPYSTR(recItem."No.", 1, STRLEN(txtText)) = UPPERCASE(txtText) THEN BEGIN
                txtText := recItem."No.";
                EXIT;
            END;

        recItem.SETCURRENTKEY("Search Description");
        recItem."Search Description" := txtText;
        recItem."No." := '';
        IF recItem.FINDFIRST THEN
            IF COPYSTR(recItem."Search Description", 1, STRLEN(txtText)) = UPPERCASE(txtText) THEN
                txtText := recItem."No.";
    end;

    [Scope('Internal')]
    procedure fGetNonstockItem(codItemNo: Code[20]; var txtItemDescription: Text[50]; codNewItemNo: Code[20]; var txtNewItemDescription: Text[50])
    var
        recNonstockItem: Record "5718";
        recNonstockItem1: Record "5718";
    begin
        IF codItemNo <> codOldItemNo THEN BEGIN
            txtItemDescription := '';
            IF codItemNo <> '' THEN
                IF recNonstockItem.GET(codItemNo) THEN
                    txtItemDescription := recNonstockItem.Description;
            codOldItemNo := codItemNo;
        END;

        IF codNewItemNo <> codOldNewItemNo THEN BEGIN
            txtNewItemDescription := '';
            IF codNewItemNo <> '' THEN
                IF recNonstockItem1.GET(codNewItemNo) THEN
                    txtNewItemDescription := recNonstockItem1.Description;
            codOldNewItemNo := codNewItemNo;
        END;
    end;
}

