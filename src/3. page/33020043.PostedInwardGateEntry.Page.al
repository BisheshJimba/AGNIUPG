page 33020043 "Posted Inward Gate Entry"
{
    Caption = 'Posted Gate Entry - Inward';
    Editable = false;
    PageType = Document;
    SourceTable = Table33020038;
    SourceTableView = SORTING(Entry Type, No.)
                      ORDER(Ascending)
                      WHERE(Entry Type=CONST(Inward));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Location Code (From)"; "Location Code (From)")
                {
                }
                field("Station From/To"; "Station From/To")
                {
                    Caption = 'Station From';
                }
                field(Description; Description)
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Posting Time"; "Posting Time")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Document Time"; "Document Time")
                {
                }
                field("LR/RR No."; "LR/RR No.")
                {
                }
                field("LR/RR Date"; "LR/RR Date")
                {
                }
                field("Vehicle No."; "Vehicle No.")
                {
                }
                field("Gate Entry No."; "Gate Entry No.")
                {
                }
            }
            part(; 33020044)
            {
                SubPageLink = Entry Type=FIELD(Entry Type),
                              Gate Entry No.=FIELD(No.);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Gate Entry")
            {
                Caption = '&Gate Entry';
                action(List)
                {
                    Caption = 'List';
                    RunObject = Page 16479;
                                    ShortCutKey = 'Shift+Ctrl+L';
                }
            }
        }
    }
}

