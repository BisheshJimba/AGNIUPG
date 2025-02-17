page 33019989 "File Navigate"
{
    PageType = NavigatePage;
    SaveValues = true;
    SourceTable = Table33019980;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'FILTERS';
                field("Document No."; "Document No.")
                {
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
                }
                field("Sub Rack No."; "Sub Rack No.")
                {
                }
            }
            repeater()
            {
                field("Table Name"; "Table Name")
                {
                    Editable = false;
                }
                field("No. of Records"; "No. of Records")
                {
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        ShowRecords;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Fi&nd")
            {
                Caption = 'Fi&nd';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FileLedgerEntry.RESET;
                    FileLedgerEntry.SETCURRENTKEY("File No.", "Rack Location", "Room No.", "Rack No.", "Sub Rack No.");
                    //FileLedgerEntry.SETFILTER(Inventory,"Document No.");
                    FileLedgerEntry.SETFILTER("File No.", "File No.");
                    FileLedgerEntry.SETFILTER("Rack Location", "Rack Location");
                    FileLedgerEntry.SETFILTER("Room No.", "Room No.");
                    FileLedgerEntry.SETFILTER("Rack No.", "Rack No.");
                    FileLedgerEntry.SETFILTER("Sub Rack No.", "Sub Rack No.");
                    FileLedgerEntry.SETRANGE(Open, TRUE);
                    IF NOT FileLedgerEntry.ISEMPTY THEN BEGIN
                        "Table Name" := 'File Ledger Entry';
                        "No. of Records" := FileLedgerEntry.COUNT;
                        ShowEnable := TRUE;
                        MODIFY;
                    END ELSE
                        ERROR('There are no records with the given filters');
                end;
            }
            action(Show)
            {
                Caption = '&Show';
                Enabled = ShowEnable;
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageMode = View;

                trigger OnAction()
                begin
                    ShowRecords;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        ShowEnable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        ShowEnable := FALSE;
    end;

    var
        FileLedgerEntry: Record "33020797";
        FileLedgerEntriesPage: Page "33019984";
        [InDataSet]
        ShowEnable: Boolean;

    [Scope('Internal')]
    procedure ShowRecords()
    begin
        FileLedgerEntry.RESET;
        FileLedgerEntry.SETCURRENTKEY("File No.", "Rack Location", "Room No.", "Rack No.", "Sub Rack No.");
        //FileLedgerEntry.SETFILTER(Inventory,"Document No.");
        FileLedgerEntry.SETFILTER("File No.", "File No.");
        FileLedgerEntry.SETFILTER("Rack Location", "Rack Location");
        FileLedgerEntry.SETFILTER("Room No.", "Room No.");
        FileLedgerEntry.SETFILTER("Rack No.", "Rack No.");
        FileLedgerEntry.SETFILTER("Sub Rack No.", "Sub Rack No.");
        FileLedgerEntry.SETRANGE(Open, TRUE);
        FileLedgerEntriesPage.SETTABLEVIEW(FileLedgerEntry);
        FileLedgerEntriesPage.RUN;
    end;
}

