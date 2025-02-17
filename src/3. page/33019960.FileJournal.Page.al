page 33019960 "File Journal"
{
    Caption = 'File Journal';
    PageType = Worksheet;
    SourceTable = Table33019981;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("File No."; "File No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Rack Location"; "Rack Location")
                {
                }
                field("Room No."; "Room No.")
                {
                }
                field("Rack No."; "Rack No.")
                {
                }
                field("Sub Rack No."; "Sub Rack No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group()
            {
            }
            action("<Action1000000012>")
            {
                Caption = 'Post Journal';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do you want to post the Journals', FALSE) THEN
                        EXIT;
                    ValidateFile;
                    PostFileJournal;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Entry No." := GetLastRecord + 1;
        "User ID" := USERID;
        "Posting Date" := TODAY;
    end;

    var
        FileJournal_G: Record "33019981";
        FileLedger_G: Record "33020797";
        EntryNo: Integer;
        FileLedgerEntry: Record "33020797";
        Window: Dialog;

    [Scope('Internal')]
    procedure GetLastRecord(): Integer
    begin
        FileJournal_G.RESET;
        IF FileJournal_G.FINDLAST THEN
            EntryNo := FileJournal_G."Entry No."
        ELSE
            EntryNo := 0;
        EXIT(EntryNo);
    end;

    [Scope('Internal')]
    procedure ValidateFile()
    begin
        FileJournal_G.RESET;
        IF FileJournal_G.FINDSET THEN
            REPEAT
                IF FileJournal_G."Document Type" = FileJournal_G."Document Type"::Others THEN BEGIN
                    FileLedger_G.RESET;
                    FileLedger_G.SETRANGE("File No.", FileJournal_G."File No.");
                    FileLedger_G.SETRANGE("Document No.", FileJournal_G."Document No.");
                    FileLedger_G.SETRANGE(Open, TRUE);
                    IF FileLedger_G.FINDFIRST THEN
                        ERROR('Document No. %1 already exists in the file %2', FileJournal_G."Document No.", FileJournal_G."File No.");
                END ELSE BEGIN
                    FileLedger_G.RESET;
                    FileLedger_G.SETRANGE("File No.", FileJournal_G."File No.");
                    FileLedger_G.SETRANGE(Open, TRUE);
                    IF FileLedger_G.FINDFIRST THEN
                        ERROR('You are not allowed to insert documents directly in to the file %1', FileJournal_G."File No.");
                END;
            UNTIL FileJournal_G.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure PostFileJournal()
    begin
        FileJournal_G.RESET;
        IF FileJournal_G.FINDSET THEN BEGIN
            Window.OPEN('###1##############' + 'Posting Journals.......\ ###2#############');
            REPEAT
                FileLedgerEntry.RESET;
                IF FileLedgerEntry.FINDLAST THEN
                    EntryNo := FileLedgerEntry."Entry No."
                ELSE
                    EntryNo := 0;

                Window.UPDATE(2, FileJournal_G."Document No.");

                FileLedgerEntry.INIT;
                FileLedgerEntry."Entry No." := EntryNo + 1;
                FileLedgerEntry."Posting Date" := FileJournal_G."Posting Date";
                FileLedgerEntry."Document Type" := FileJournal_G."Document Type";
                FileLedgerEntry."Document No." := FileJournal_G."Document No.";
                FileLedgerEntry."Location Code" := FileJournal_G."Location Code";
                FileLedgerEntry."File No." := FileJournal_G."File No.";
                FileLedgerEntry."User ID" := FileJournal_G."User ID";
                FileLedgerEntry."Entry Type" := FileLedgerEntry."Entry Type"::Initial;
                FileLedgerEntry."Resp Center / Jou Temp" := FileJournal_G."Resp Center / Jou Temp";
                FileLedgerEntry.Open := TRUE;
                FileLedgerEntry."Rack Location" := FileJournal_G."Rack Location";
                FileLedgerEntry."Room No." := FileJournal_G."Room No.";
                FileLedgerEntry."Rack No." := FileJournal_G."Rack No.";
                FileLedgerEntry."Sub Rack No." := FileJournal_G."Sub Rack No.";
                FileLedgerEntry."Shortcut Dimension 1 Code" := FileJournal_G."Shortcut Dimension 1 Code";
                FileLedgerEntry."Shortcut Dimension 2 Code" := FileJournal_G."Shortcut Dimension 2 Code";
                FileLedgerEntry.INSERT;

                FileJournal_G.DELETE;

            UNTIL FileJournal_G.NEXT = 0;
            Window.CLOSE;
            MESSAGE('Journal Posted Successfully');
        END;
    end;
}

