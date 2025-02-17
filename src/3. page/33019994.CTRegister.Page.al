page 33019994 "C/T Register"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Ledger,Posted Document';
    RefreshOnActivate = true;
    SourceTable = Table33019969;
    SourceTableView = ORDER(Ascending)
                      WHERE(Entry From=CONST(Courier));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("Source Code"; "Source Code")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("From Entry No."; "From Entry No.")
                {
                }
                field("To Entry No."; "To Entry No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1102159018>")
            {
                Caption = 'Register';
                action(Courier_Ledger)
                {
                    Caption = 'Courier Ledger';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 33019995;
                    RunPageLink = Document No.=FIELD(Document No.),
                                  Document No.=FIELD(From Entry No.),
                                  Document No.=FIELD(To Entry No.);
                    RunPageMode = View;
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                action(Posted_Shipment)
                {
                    Caption = 'Shipments';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page 33019982;
                                    RunPageLink = Field2=FIELD(Document No.);
                    RunPageMode = View;
                }
                action(Posted_Receipt)
                {
                    Caption = 'Receipts';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page 33019985;
                                    RunPageLink = Field2=FIELD(Document No.);
                    RunPageMode = View;
                }
                action(Posted_ReturnRcpt)
                {
                    Caption = 'Return Receipt';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page 33019988;
                                    RunPageLink = Room Code=FIELD(Document No.);
                    RunPageMode = View;
                }
            }
        }
        area(reporting)
        {
            action(CT_Register)
            {
                Caption = 'C/T Register';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 33019979;

    trigger OnAction()
    begin
        MESSAGE('Run C/T Register report');
    end;
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

