page 33019974 "Posted Stock-Fuel Issue List"
{
    CardPageID = "Posted Stock-Fuel Issue Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Ledger,Documents';
    RefreshOnActivate = true;
    SourceTable = Table33019967;
    SourceTableView = WHERE(Document Type=CONST(Stock));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("VIN (Chasis No.)"; "VIN (Chasis No.)")
                {
                    Caption = 'Chasis No.';
                }
                field("Issue Type"; "Issue Type")
                {
                }
                field("Movement Type"; "Movement Type")
                {
                }
                field("Fuel Type"; "Fuel Type")
                {
                }
                field("From City Name"; "From City Name")
                {
                }
                field("To City Name"; "To City Name")
                {
                }
                field("Purpose of Travel"; "Purpose of Travel")
                {
                }
                field("Petrol Pump Name"; "Petrol Pump Name")
                {
                }
                field("Issue Date"; "Issue Date")
                {
                }
                field(Location; Location)
                {
                }
                field(Department; Department)
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
        area(reporting)
        {
            group(Documents)
            {
                Caption = 'Documents';
                action("<Action1102159048>")
                {
                    Caption = 'Coupon';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        PostedFuelIssueEntry: Record "33019967";
                    begin
                        //Viewing report with selection filter.
                        PostedFuelIssueEntry.RESET;
                        PostedFuelIssueEntry.SETRANGE("Document Type", "Document Type");
                        PostedFuelIssueEntry.SETRANGE("No.", "No.");
                        REPORT.RUN(33019964, TRUE, TRUE, PostedFuelIssueEntry);
                    end;
                }
            }
        }
        area(navigation)
        {
            action("<Action1102159056>")
            {
                Caption = 'Fuel Ledger';
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33019978;
                RunPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(No.),
                              Document Date=FIELD(Document Date);
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

