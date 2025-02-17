codeunit 25006311 "Vehicle Opt. Jnl.-B.Post"
{
    // //==================================================================================================================================
    // MërÒis: Ÿrnâla grâmato³anas pamata jeb sâkuma koda bloks - no ¹urnâla iedaÔâm
    // 
    // //==================================================================================================================================

    TableNo = 25006386;

    trigger OnRun()
    begin
        recVehOptJnlBatch.COPY(Rec);
        fCode;
        Rec.COPY(recVehOptJnlBatch);
    end;

    var
        Text000: Label 'Do you want to post the journals?';
        Text001: Label 'The journals were successfully posted.';
        Text002: Label 'It was not possible to post all of the journals. ';
        Text003: Label 'The journals that were not successfully posted are now marked.';
        recVehOptJnlTemplate: Record "25006385";
        recVehOptJnlBatch: Record "25006386";
        recVehOptJnlLine: Record "25006387";
        cuVehOptJnlPostBatch: Codeunit "25006308";
        bJnlWithErrors: Boolean;

    local procedure fCode()
    begin
        recVehOptJnlTemplate.GET(recVehOptJnlBatch."Journal Template Name");
        recVehOptJnlTemplate.TESTFIELD("Force Posting Report", FALSE);

        IF NOT CONFIRM(Text000, FALSE) THEN
            EXIT;

        recVehOptJnlBatch.FINDSET;
        REPEAT
            recVehOptJnlLine."Journal Template Name" := recVehOptJnlBatch."Journal Template Name";
            recVehOptJnlLine."Journal Batch Name" := recVehOptJnlBatch.Name;
            recVehOptJnlLine."Line No." := 1;
            CLEAR(cuVehOptJnlPostBatch);
            IF cuVehOptJnlPostBatch.RUN(recVehOptJnlLine) THEN
                recVehOptJnlBatch.MARK(FALSE)
            ELSE BEGIN
                recVehOptJnlBatch.MARK(TRUE);
                bJnlWithErrors := TRUE;
            END;
        UNTIL recVehOptJnlBatch.NEXT = 0;

        IF NOT bJnlWithErrors THEN
            MESSAGE(Text001)
        ELSE
            MESSAGE(
              Text002 +
              Text003);

        IF NOT recVehOptJnlBatch.FINDSET THEN BEGIN
            recVehOptJnlBatch.RESET;
            recVehOptJnlBatch.FILTERGROUP(2);
            recVehOptJnlBatch.SETRANGE("Journal Template Name", recVehOptJnlBatch."Journal Template Name");
            recVehOptJnlBatch.FILTERGROUP(0);
            recVehOptJnlBatch.Name := '';
        END;
    end;
}

