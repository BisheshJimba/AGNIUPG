page 33020794 "File Tracking Card"
{
    SourceTable = Table33020798;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group("Close File")
            {
                field("Document Type"; "Document Type")
                {
                    Editable = false;
                }
                field("Resp Center / Jou Temp"; "Resp Center / Jou Temp")
                {
                    Editable = false;
                    Visible = false;
                }
                field("File No."; "File No.")
                {
                }
                field("From Document No."; "From Document No.")
                {
                }
                field("To Document No."; "To Document No.")
                {
                    Editable = true;
                }
                field("Creation Date"; "Creation Date")
                {
                    Editable = false;
                }
                field("Location Code"; "Location Code")
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
                field("Responsible Person"; "Responsible Person")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Close File")
            {
                Image = Lock;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    subrack: Record "33020792";
                    FileLedgerEntry: Record "33020797";
                begin
                    IF NOT CONFIRM('Are you Sure you want to close the file', FALSE) THEN BEGIN
                        CurrPage.CLOSE;
                    END
                    ELSE BEGIN
                        FileLedgerEntry.RESET;
                        FileLedgerEntry.SETRANGE("File No.", Rec."File No.");
                        IF FileLedgerEntry.FINDFIRST THEN
                            ERROR('File No. already exist');
                        subrack.RESET;
                        subrack.SETRANGE("Room Code", Rec."Room No.");
                        subrack.SETRANGE("Sub Rack Code", Rec."Sub Rack No.");
                        subrack.SETRANGE("Location Code", Rec."Location Code");
                        subrack.SETRANGE("Rack Code", Rec."Rack No.");
                        IF subrack.FINDFIRST THEN BEGIN
                            subrack.CALCFIELDS(Consumed);
                            IF subrack.Capacity = subrack.Consumed THEN
                                ERROR('Subrack %1 is full', Rec."Sub Rack No.");
                        END;
                        IF CloseFileDetails(Rec, FileDetail, FileMgtSetup) THEN BEGIN
                            MESSAGE('File %1 has been closed successfully.', "File No.");
                            DELETEALL;
                        END;
                    END;
                end;
            }
        }
    }

    var
        FileDetail: Record "33020798";
        FileMgtSetup: Record "33020795";
        UserSetup: Record "91";
        CompInfo: Record "79";
        DocNoVisibility: Boolean;

    [Scope('Internal')]
    procedure SetSource(var _FileDetail: Record "33020798"; _FileMgtSetup: Record "33020795")
    begin
        DELETEALL;
        FileDetail := _FileDetail;
        FileMgtSetup := _FileMgtSetup;
        INIT;
        TRANSFERFIELDS(FileDetail);
        UserSetup.GET(USERID);
        "Location Code" := FileMgtSetup."Default Rack Location";
        "Room No." := FileMgtSetup."Default Room No.";
        "Rack No." := FileMgtSetup."Default Rack No.";
        "Sub Rack No." := FileMgtSetup."Default Sub Rack No.";
        IF GetLastDocumentNo <> '' THEN
            "From Document No." := GetLastDocumentNo;
        "Location Code" := UserSetup."Default Location";
        INSERT;
    end;

    [Scope('Internal')]
    procedure GetLastDocumentNo(): Code[20]
    var
        FileDetailRec: Record "33020798";
    begin
        FileDetailRec.RESET;
        FileDetailRec.SETRANGE("Document Type", FileDetail."Document Type");
        FileDetailRec.SETRANGE("Resp Center / Jou Temp", FileDetail."Resp Center / Jou Temp");
        FileDetailRec.SETRANGE(Close, TRUE);
        IF FileDetailRec.FINDLAST THEN
            EXIT(INCSTR(FileDetailRec."To Document No."));
    end;
}

