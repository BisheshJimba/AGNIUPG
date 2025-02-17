page 33019971 "Posted Coupon-Fuel Issue Card"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Ledger,Documents';
    RefreshOnActivate = true;
    SourceTable = Table33019967;
    SourceTableView = WHERE(Document Type=CONST(Coupon));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field(Location; Location)
                {
                }
                field(Department; Department)
                {
                }
                field("Issued For"; "Issued For")
                {
                }
                field(Manufacturer; Manufacturer)
                {
                }
                field("Issue Type"; "Issue Type")
                {
                }
                field("Movement Type"; "Movement Type")
                {
                }
                field("Registration No."; "Registration No.")
                {
                    Caption = 'Registration No.';
                }
                field("Kilometerage (KM)"; "Kilometerage (KM)")
                {
                    Caption = 'Last Visit KM';
                }
                field("Issue Date"; "Issue Date")
                {
                }
                field("Add Additional City"; "Add Additional City")
                {
                }
            }
            group(Staff_Info)
            {
                Caption = 'Staff Information';
                field("Staff No."; "Staff No.")
                {
                }
                field("Staff Name"; "Staff Name")
                {
                }
            }
            group(Vehicle_Info)
            {
                Caption = 'Vehicle Information';
                field("VIN (Chasis No.)"; "VIN (Chasis No.)")
                {
                    Caption = 'Chasis No.';
                }
                field(" Registration No. "; "Registration No.")
                {
                    Caption = 'Registration No.';
                }
                field(Mileage; Mileage)
                {
                }
                field("Kilometerage (KM) "; "Kilometerage (KM)")
                {
                }
            }
            group(Coupon_Info)
            {
                Caption = 'Coupon Information';
                field("From City Code"; "From City Code")
                {
                }
                field("From City Name"; "From City Name")
                {
                }
                field("To City Code"; "To City Code")
                {
                }
                field("To City Name"; "To City Name")
                {
                }
                field(Distance; Distance)
                {
                }
                field("Issued Fuel (Litre)"; "Issued Fuel (Litre)")
                {
                }
                field("Issued Fuel Add. (Litre)"; "Issued Fuel Add. (Litre)")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field("Petrol Pump Code"; "Petrol Pump Code")
                {
                }
                field("Petrol Pump Name"; "Petrol Pump Name")
                {
                }
                field("Issued Coupon No."; "Issued Coupon No.")
                {
                }
                field("Fuel Type"; "Fuel Type")
                {
                }
                field("Purpose of Travel"; "Purpose of Travel")
                {
                }
                field("Rate (Rs.)"; "Rate (Rs.)")
                {
                }
                field("Amount (Rs.)"; "Amount (Rs.)")
                {
                }
                field("Issued To"; "Issued To")
                {
                }
            }
            group(Additional_Info)
            {
                Caption = 'Addition';
                field("Add. From City Code"; "Add. From City Code")
                {
                }
                field("Add. From City Name"; "Add. From City Name")
                {
                }
                field("Add. To City Name"; "Add. To City Name")
                {
                }
                field("Add. Distance"; "Add. Distance")
                {
                }
                field("Add. Litre"; "Add. Litre")
                {
                }
                field("Add. Litre (Add.)"; "Add. Litre (Add.)")
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
                        REPORT.RUN(33019962, TRUE, TRUE, PostedFuelIssueEntry);
                    end;
                }
            }
        }
        area(navigation)
        {
            action("Fuel Ledger")
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

