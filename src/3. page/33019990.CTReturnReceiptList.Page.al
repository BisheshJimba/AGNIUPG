page 33019990 "CT Return Receipt List"
{
    CardPageID = "SubRack- File Mgmt";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Ledger,Documents';
    RefreshOnActivate = true;
    SourceTable = Table33019994;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Return No."; "Return No.")
                {
                }
                field("CT No."; "CT No.")
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
            action(Ret_RcptLedger)
            {
                Caption = 'Return Receipt Ledger';
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
                action(Posted_RetRcpt)
                {
                    Caption = 'Return Receipt';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        LocalCourTrackRetShipHdr: Record "33019994";
                    begin
                        LocalCourTrackRetShipHdr.RESET;
                        LocalCourTrackRetShipHdr.SETRANGE("No.","No.");
                        REPORT.RUN(33019978,TRUE,TRUE,LocalCourTrackRetShipHdr);
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

