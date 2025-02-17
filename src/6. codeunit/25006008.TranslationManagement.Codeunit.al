codeunit 25006008 "Translation Management"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure fItemTranslationToNonstock(var recItemTranslation: Record "30"; var xrecItemTranslation: Record "30"; intActivity: Integer)
    var
        recItem: Record "27";
        recNonstockItem: Record "5718";
        recNonstockItemTranslation: Record "25006759";
    begin
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */


        IF NOT recItem.GET(recItemTranslation."Item No.") THEN
            EXIT;
        IF NOT recItem."Created From Nonstock Item" THEN
            EXIT;

        recNonstockItem.RESET;
        recNonstockItem.SETCURRENTKEY("Item No.");
        recNonstockItem.SETRANGE("Item No.", recItem."No.");
        IF recNonstockItem.ISEMPTY THEN
            EXIT;

        CASE intActivity OF
            0: //Insert
                BEGIN
                    recNonstockItemTranslation.INIT;
                    recNonstockItemTranslation."Nonstock Item Entry No." := recItemTranslation."Item No.";
                    recNonstockItemTranslation."Language Code" := recItemTranslation."Language Code";
                    recNonstockItemTranslation.Description := recItemTranslation.Description;
                    recNonstockItemTranslation."Description 2" := recItemTranslation."Description 2";
                    recNonstockItemTranslation.INSERT;
                END;
            1, 2: //modify,rename
                BEGIN
                    recNonstockItemTranslation.RESET;
                    recNonstockItemTranslation.SETRANGE("Nonstock Item Entry No.", xrecItemTranslation."Item No.");
                    recNonstockItemTranslation.SETRANGE("Language Code", xrecItemTranslation."Language Code");

                    IF recNonstockItemTranslation.FINDSET THEN
                        recNonstockItemTranslation.DELETE;

                    recNonstockItemTranslation.INIT;
                    recNonstockItemTranslation."Nonstock Item Entry No." := recItemTranslation."Item No.";
                    recNonstockItemTranslation."Language Code" := recItemTranslation."Language Code";
                    recNonstockItemTranslation.Description := recItemTranslation.Description;
                    recNonstockItemTranslation."Description 2" := recItemTranslation."Description 2";
                    recNonstockItemTranslation.INSERT;
                END;
            3:  //delete
                BEGIN
                    recNonstockItemTranslation.RESET;
                    recNonstockItemTranslation.SETRANGE("Nonstock Item Entry No.", recItemTranslation."Item No.");
                    recNonstockItemTranslation.SETRANGE("Language Code", recItemTranslation."Language Code");

                    IF recNonstockItemTranslation.FINDSET THEN
                        recNonstockItemTranslation.DELETE;
                END;
        END;

    end;

    [Scope('Internal')]
    procedure fNonstockTranslationToItem(var recNonstockItemTranslation: Record "25006759"; var xrecNonstockItemTranslation: Record "25006759"; intActivity: Integer)
    var
        recItem: Record "27";
        recNonstockItem: Record "5718";
        recItemTranslation: Record "30";
    begin
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */

        IF NOT recNonstockItem.GET(recNonstockItemTranslation."Nonstock Item Entry No.") THEN
            EXIT;
        IF recNonstockItem."Item No." = '' THEN
            EXIT;
        IF NOT recItem.GET(recNonstockItem."Item No.") THEN
            EXIT;

        recNonstockItem.TESTFIELD("Item No.", recNonstockItem."Entry No.");

        CASE intActivity OF
            0: //Insert
                BEGIN
                    recItemTranslation.INIT;
                    recItemTranslation."Item No." := recNonstockItemTranslation."Nonstock Item Entry No.";
                    recItemTranslation."Language Code" := recNonstockItemTranslation."Language Code";
                    recItemTranslation.Description := recNonstockItemTranslation.Description;
                    recItemTranslation."Description 2" := recNonstockItemTranslation."Description 2";
                    recItemTranslation.INSERT;

                END;
            1, 2: //modify,rename
                BEGIN
                    recItemTranslation.RESET;
                    recItemTranslation.SETRANGE("Item No.", xrecNonstockItemTranslation."Nonstock Item Entry No.");
                    recItemTranslation.SETRANGE("Language Code", xrecNonstockItemTranslation."Language Code");

                    IF recItemTranslation.FINDSET THEN
                        recItemTranslation.DELETE;

                    recItemTranslation.INIT;
                    recItemTranslation."Item No." := recNonstockItemTranslation."Nonstock Item Entry No.";
                    recItemTranslation."Language Code" := recNonstockItemTranslation."Language Code";
                    recItemTranslation.Description := recNonstockItemTranslation.Description;
                    recItemTranslation."Description 2" := recNonstockItemTranslation."Description 2";
                    recItemTranslation.INSERT;
                END;
            3:  //delete
                BEGIN
                    recItemTranslation.RESET;
                    recItemTranslation.SETRANGE("Item No.", recNonstockItemTranslation."Nonstock Item Entry No.");
                    recItemTranslation.SETRANGE("Language Code", recNonstockItemTranslation."Language Code");

                    IF recItemTranslation.FINDSET THEN
                        recItemTranslation.DELETE;
                END;
        END;

    end;
}

