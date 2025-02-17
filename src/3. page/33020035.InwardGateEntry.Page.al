page 33020035 "Inward Gate Entry"
{
    Caption = 'Gate Entry - Inward';
    PageType = Document;
    SourceTable = Table33020035;
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

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                        /*
                            GateEntryLocSetup.GET("Entry Type","Location Code");
                          GateEntryLocSetup.TESTFIELD("Posting No. Series");
                          IF NoSeriesMgt.SelectSeries(GateEntryLocSetup."Posting No. Series","No.","No. Series") THEN
                             NoSeriesMgt.SetSeries("No.");
                        */

                    end;
                }
                field("Location Code"; "Location Code")
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
                field("Document Date"; "Document Date")
                {
                }
                field("Document Time"; "Document Time")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Posting Time"; "Posting Time")
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
            }
            part(; 33020036)
            {
                SubPageLink = Entry Type=FIELD(Entry Type),
                              Gate Entry No.=FIELD(No.);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Po&st")
                {
                    Caption = 'Po&st';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit 33020036;
                    ShortCutKey = 'F9';
                }
            }
        }
    }

    var
        GateEntryLocSetup: Record "33020037";
        NoSeriesMgt: Codeunit "396";
}

