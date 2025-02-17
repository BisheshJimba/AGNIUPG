page 25006160 "Service Package Card"
{
    Caption = 'Service Package Card';
    DataCaptionExpression = STRSUBSTNO('%1 Nr. %2', Type, "No.");
    PageType = Card;
    SourceTable = Table25006134;

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
                        IF AssistEdit THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Type; Type)
                {
                }
                field("Make Code"; "Make Code")
                {

                    trigger OnValidate()
                    begin
                        MakeCodeOnAfterValidate;
                    end;
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Group Code"; "Group Code")
                {
                }
                field("Subgroup Code"; "Subgroup Code")
                {
                }
                field("Search Description"; "Search Description")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Campaign No."; "Campaign No.")
                {
                    Visible = false;
                }
                field("Recall Campaign No."; "Recall Campaign No.")
                {
                }
                field("Total Amount (Sanjivani)"; "Total Amount (Sanjivani)")
                {
                }
                field("Validity (Sanjivani)"; "Validity (Sanjivani)")
                {
                }
                field("Limit Amount (Sanjivani)"; "Limit Amount (Sanjivani)")
                {
                }
                field("Hide Line Amount"; "Hide Line Amount")
                {
                }
            }
            part(PackageVersionLines; 25006162)
            {
                Caption = 'Versions';
                SubPageLink = Package No.=FIELD(No.);
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Free of Charge"; "Free of Charge")
                {
                }
                field("Fixed Prices and Discounts"; "Fixed Prices and Discounts")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Package)
            {
                Caption = 'Package';
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page 25006187;
                    RunPageLink = Type = CONST(Service Package),
                                  No.=FIELD(No.);
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action("Recalculate Prices")
                {
                    Caption = 'Recalculate Prices';
                    Image = Recalculate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.PackageVersionLines.PAGE.GETRECORD(recServPackVersion);
                        recServPackVersion.SETRANGE("Package No.",recServPackVersion."Package No.");
                        recServPackVersion.SETRANGE("Version No.",recServPackVersion."Version No.");

                        REPORT.RUN(REPORT::"Upd. Package Ver. Spec. Prices",TRUE,TRUE,recServPackVersion);
                    end;
                }
            }
        }
    }

    var
        recServPackVersion: Record "25006135";

    local procedure MakeCodeOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

