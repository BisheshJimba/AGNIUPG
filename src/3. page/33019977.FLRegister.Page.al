page 33019977 "F/L Register"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Ledger,Posted Documents';
    RefreshOnActivate = true;
    SourceTable = Table33019969;
    SourceTableView = ORDER(Ascending)
                      WHERE(Entry From=CONST(Fuel));

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
                field("Journal Batch Name"; "Journal Batch Name")
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
            group(Register)
            {
                Caption = 'Register';
                action(Fuel_Ledger)
                {
                    Caption = 'Fuel Ledger';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 33019978;
                    RunPageLink = Document No.=FIELD(Document No.),
                                  Entry No.=FIELD(From Entry No.),
                                  Entry No.=FIELD(To Entry No.);
                    RunPageMode = View;
                }
            }
            group("Posted Document")
            {
                Caption = 'Posted Document';
                action(Posted_Coupon_Card)
                {
                    Caption = 'Posted Coupon';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunPageMode = View;

                    trigger OnAction()
                    var
                        PostedFuelIssueEntry: Record "33019967";
                        PostedCouponCard: Page "33019971";
                                              Text33019961: Label 'Posted document cannot be opened. Please select the correct line. ';
                    begin
                        //Opening Posted Coupon Fuel Entry Card with condition.
                        PostedFuelIssueEntry.RESET;
                        PostedFuelIssueEntry.SETFILTER("Document Type",'Coupon');
                        PostedFuelIssueEntry.SETRANGE("No.","Document No.");
                        IF PostedFuelIssueEntry.FIND('-') THEN BEGIN
                          PostedCouponCard.SETTABLEVIEW(PostedFuelIssueEntry);
                          PostedCouponCard.RUNMODAL;
                        END ELSE
                          MESSAGE(Text33019961);
                    end;
                }
                action(Posted_Stock_Card)
                {
                    Caption = 'Posted Stock';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunPageMode = View;

                    trigger OnAction()
                    var
                        PostedFuelIssueEntry: Record "33019967";
                        PostedStockCard: Page "33019973";
                                             Text33019961: Label 'Posted document cannot be opened. Please select the correct line. ';
                    begin
                        //Opening Posted Coupon Fuel Entry Card with condition.
                        PostedFuelIssueEntry.RESET;
                        PostedFuelIssueEntry.SETFILTER("Document Type",'Stock');
                        PostedFuelIssueEntry.SETRANGE("No.","Document No.");
                        IF PostedFuelIssueEntry.FIND('-') THEN BEGIN
                          PostedStockCard.SETTABLEVIEW(PostedFuelIssueEntry);
                          PostedStockCard.RUNMODAL;
                        END ELSE
                          MESSAGE(Text33019961);
                    end;
                }
                action(Posted_Cash_Card)
                {
                    Caption = 'Posted Cash';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunPageMode = View;

                    trigger OnAction()
                    var
                        PostedFuelIssueEntry: Record "33019967";
                        PostedCashCard: Page "33019975";
                                            Text33019961: Label 'Posted document cannot be opened. Please select the correct line. ';
                    begin
                        //Opening Posted Coupon Fuel Entry Card with condition.
                        PostedFuelIssueEntry.RESET;
                        PostedFuelIssueEntry.SETFILTER("Document Type",'Cash');
                        PostedFuelIssueEntry.SETRANGE("No.","Document No.");
                        IF PostedFuelIssueEntry.FIND('-') THEN BEGIN
                          PostedCashCard.SETTABLEVIEW(PostedFuelIssueEntry);
                          PostedCashCard.RUNMODAL;
                        END ELSE
                          MESSAGE(Text33019961);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("<Action1102159026>")
            {
                Caption = 'F/L Register';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 33019967;

    trigger OnAction()
    var
        FuelRegister: Record "33019969";
        FuelRegReport: Report "33019967";
    begin
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

