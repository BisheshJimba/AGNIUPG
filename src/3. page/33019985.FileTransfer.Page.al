page 33019985 "File Transfer"
{
    PageType = Worksheet;
    SourceTable = Table33020796;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {

                    trigger OnValidate()
                    begin
                        "Entry Type" := "Entry Type"::Transfer;
                    end;
                }
                field("File No."; "File No.")
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
                    TableRelation = "Rack - File Mgmt"."Rack Code" WHERE(Room Code=FIELD(Room No.));
                }
                field("Sub Rack No."; "Sub Rack No.")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Issued Date"; "Issued Date")
                {
                }
                field("Expected Received Date"; "Expected Received Date")
                {
                }
                field(Reason; Reason)
                {
                }
                field("Received Date"; "Received Date")
                {
                }
                field("Responsible Person"; "Responsible Person")
                {
                }
                field("External Transfer"; "External Transfer")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000011>")
            {
                Caption = 'Transfer Files';

                trigger OnAction()
                begin
                    IF Rec.FINDSET THEN
                        REPEAT
                            IF Rec."External Transfer" THEN
                                Rec.TESTFIELD(Reason);
                        UNTIL Rec.NEXT = 0;
                    CurrPage.SETSELECTIONFILTER(FileTransfer);
                    //IF FileTransfer."External Transfer" THEN
                    //FileTransfer.TESTFIELD(Reason);
                    IF FileTransfer.FINDFIRST THEN BEGIN
                        SubRack.RESET;
                        SubRack.SETRANGE("Room Code", FileTransfer."Room No.");
                        SubRack.SETRANGE("Rack Code", FileTransfer."Rack No.");
                        SubRack.SETRANGE("Location Code", FileTransfer."Rack Location");
                        SubRack.SETRANGE("Sub Rack Code", FileTransfer."Sub Rack No.");
                        IF SubRack.FINDFIRST THEN BEGIN
                            SubRack.CALCFIELDS(Consumed);
                            IF SubRack.Capacity = SubRack.Consumed THEN
                                ERROR('SubRack is full');
                        END;
                        FileLedgerEntry2.RESET;
                        FileLedgerEntry2.SETRANGE("File No.", FileTransfer."File No.");
                        FileLedgerEntry2.SETRANGE(Open, TRUE);
                        IF FileLedgerEntry2.FINDFIRST THEN BEGIN
                            IF (FileLedgerEntry2."Room No." = FileTransfer."Room No.") AND (FileLedgerEntry2."Rack No." = FileTransfer."Rack No.") AND (FileLedgerEntry2."Sub Rack No." = FileTransfer."Sub Rack No.") THEN
                                ERROR('You cannot transfer the file %1 in to the same location', FileTransfer."File No.");

                            FileLedgerEntry.RESET;
                            IF FileLedgerEntry.FINDLAST THEN
                                EntryNo := FileLedgerEntry."Entry No." + 1
                            ELSE
                                EntryNo := 0;
                            FileLedgerEntry.INIT;
                            FileLedgerEntry."Entry No." := EntryNo;
                            FileLedgerEntry."Posting Date" := TODAY;
                            FileLedgerEntry."Document Type" := FileLedgerEntry2."Document Type";
                            FileLedgerEntry."Document No." := FileLedgerEntry2."Document No.";
                            FileLedgerEntry."Location Code" := FileLedgerEntry2."Location Code";
                            FileLedgerEntry."File No." := FileLedgerEntry2."File No.";
                            FileLedgerEntry."Rack Location" := FileTransfer."Rack Location";
                            FileLedgerEntry."Room No." := FileTransfer."Room No.";
                            FileLedgerEntry."Rack No." := FileTransfer."Rack No.";
                            FileLedgerEntry."Sub Rack No." := FileTransfer."Sub Rack No.";
                            FileLedgerEntry."User ID" := USERID;
                            FileLedgerEntry."Entry Type" := FileLedgerEntry."Entry Type"::Transfer;
                            FileLedgerEntry."Loan No." := FileTransfer."Loan No.";
                            FileLedgerEntry."Issued Date" := FileTransfer."Issued Date";
                            FileLedgerEntry."Expected Received Date" := FileTransfer."Expected Received Date";
                            FileLedgerEntry."Received Date" := FileTransfer."Received Date";
                            FileLedgerEntry.Reason := FileTransfer.Reason;
                            FileLedgerEntry."Responsible Person" := FileTransfer."Responsible Person";
                            FileLedgerEntry.Open := TRUE;
                            FileLedgerEntry."External Transfer" := FileTransfer."External Transfer";
                            FileLedgerEntry.INSERT;

                            FileLedgerEntry2.Open := FALSE;
                            FileLedgerEntry2.MODIFY;

                            FileDetail.RESET;
                            FileDetail.SETRANGE("File No.", FileTransfer."File No.");
                            IF FileDetail.FINDFIRST THEN BEGIN
                                FileDetail."Location Code" := FileTransfer."Rack Location";
                                FileDetail."Room No." := FileTransfer."Room No.";
                                FileDetail."Rack No." := FileTransfer."Rack No.";
                                FileDetail."Sub Rack No." := FileTransfer."Sub Rack No.";
                                FileDetail."Responsible Person" := FileTransfer."Responsible Person";
                                FileDetail."External Transfer" := FileTransfer."External Transfer";
                                FileDetail.MODIFY;
                            END;
                        END ELSE
                            ERROR('There is Nothing to transfer against the file %1 ', FileTransfer."File No.");

                        FileTransfer.DELETE;
                    END;
                end;
            }
            action("Current File Details")
            {
                Image = Description;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FileLedEntry: Record "33020797";
                begin
                    FileLedEntry.RESET;
                    FileLedEntry.SETRANGE("File No.", "File No.");
                    FileLedEntry.SETRANGE(Open, TRUE);
                    IF FileLedEntry.FINDLAST THEN
                        PAGE.RUNMODAL(33019984, FileLedEntry);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Entry Type" := "Entry Type"::Transfer;
    end;

    var
        FileLedgerEntry: Record "33020797";
        FileLedgerEntry2: Record "33020797";
        FileTransfer: Record "33020796";
        EntryNo: Integer;
        FileLed: Record "33020797";
        SubRack: Record "33020792";
        FileDetail: Record "33020798";
}

