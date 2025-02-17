page 50031 "CT Receipt Header"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Ledger,Documents';
    SourceTable = Table33019991;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("Transfer From Code"; "Transfer From Code")
                {
                }
                field("Transfer To Code"; "Transfer To Code")
                {
                }
                field("Transfer From Department"; "Transfer From Department")
                {
                }
                field("Transfer To Department"; "Transfer To Department")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Transfer No."; "Transfer No.")
                {
                }
            }
            part(Lines; 50032)
            {
                Caption = 'Lines';
                SubPageLink = Transfer-from Code=FIELD(No.);
            }
            group("Transfer From")
            {
                field("Transfer From Name"; "Transfer From Name")
                {
                }
                field("Transfer From Address"; "Transfer From Address")
                {
                }
                field("Transfer From Address 2"; "Transfer From Address 2")
                {
                }
                field("Transfer From Post Code"; "Transfer From Post Code")
                {
                }
                field("Transfer From City"; "Transfer From City")
                {
                }
                field("Transfer From Contact"; "Transfer From Contact")
                {
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                }
                field("Shipping Time"; "Shipping Time")
                {
                }
            }
            group("Transfer To")
            {
                field("Transfer To Name"; "Transfer To Name")
                {
                }
                field("Transfer To Address"; "Transfer To Address")
                {
                }
                field("Transfer To Address 2"; "Transfer To Address 2")
                {
                }
                field("Transfer To Post Code"; "Transfer To Post Code")
                {
                }
                field("Transfer To City"; "Transfer To City")
                {
                }
                field("Transfer To Contact"; "Transfer To Contact")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
            }
            group(Shipping)
            {
                field("Transaction Type"; "Transaction Type")
                {
                }
                field("Transport Method"; "Transport Method")
                {
                }
                field("CT No."; "CT No.")
                {
                }
                field(Insurance; Insurance)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Courier_Ledger)
            {
                Caption = 'Receipt Ledger';
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33019995;
                RunPageLink = Document No.=FIELD(No.);
            }
        }
        area(reporting)
        {
            group(Documents)
            {
                Caption = 'Documents';
                action(Posted_Shipment)
                {
                    Caption = 'Print Receipt';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        LocalCourTrackRecptHdr: Record "33019991";
                    begin
                        //Setting filter and viewing report.
                        LocalCourTrackRecptHdr.RESET;
                        LocalCourTrackRecptHdr.SETRANGE("No.","No.");
                        REPORT.RUN(33019974,TRUE,TRUE,LocalCourTrackRecptHdr);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Setting responsibility center user wise.
        UserSetup.GET(USERID);
        IF UserSetup."Apply Rules" THEN BEGIN
          IF (UserSetup."Default Responsibility Center" <> '') THEN BEGIN
            FILTERGROUP(0);
            SETFILTER("Responsibility Center",UserSetup."Default Responsibility Center");
            FILTERGROUP(2);
          END;
        END;
    end;

    var
        UserSetup: Record "91";
}

