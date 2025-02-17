page 25006381 "Service WIP Worksheet"
{
    PageType = List;
    SourceTable = Table25006192;

    layout
    {
        area(content)
        {
            group("Service Orders")
            {
                Caption = 'Service Orders';
                repeater(Group)
                {
                    Caption = 'Service Orders';
                    field("Service Order No."; "Service Order No.")
                    {
                    }
                    field("Service Order Date"; "Service Order Date")
                    {
                    }
                    field("Sell-to Customer No."; "Sell-to Customer No.")
                    {
                    }
                    field("Sell-to Customer Name"; "Sell-to Customer Name")
                    {
                    }
                    field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                    {
                    }
                    field(Amount; Amount)
                    {
                    }
                    field("WIP Date"; "WIP Date")
                    {
                    }
                    field("Bill-to Customer No."; "Bill-to Customer No.")
                    {
                    }
                    field("Bill-to Name"; "Bill-to Name")
                    {
                    }
                    field("Location Code"; "Location Code")
                    {
                    }
                    field("Currency Code"; "Currency Code")
                    {
                    }
                    field("Currency Factor"; "Currency Factor")
                    {
                    }
                    field("Prices Including VAT"; "Prices Including VAT")
                    {
                    }
                    field(VIN; VIN)
                    {
                    }
                    field("Vehicle Registration No."; "Vehicle Registration No.")
                    {
                    }
                    field("Make Code"; "Make Code")
                    {
                    }
                    field("Model Code"; "Model Code")
                    {
                    }
                    field("Vehicle Serial No."; "Vehicle Serial No.")
                    {
                    }
                    field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
                    {
                    }
                    field("Item Cost Amt."; "Item Cost Amt.")
                    {
                    }
                    field("Item Sales Amt."; "Item Sales Amt.")
                    {
                    }
                    field("Labor Cost Amt."; "Labor Cost Amt.")
                    {
                    }
                    field("Labor Sales Amt."; "Labor Sales Amt.")
                    {
                    }
                    field("Ext. S. Cost Amt."; "Ext. S. Cost Amt.")
                    {
                    }
                    field("Ext. S. Sales Amt."; "Ext. S. Sales Amt.")
                    {
                    }
                    field("Total Cost Amt."; "Total Cost Amt.")
                    {
                    }
                    field("Total Sales Amt."; "Total Sales Amt.")
                    {
                    }
                }
            }
            part(; 25006382)
            {
                SubPageLink = Service Order No.=FIELD(Service Order No.);
            }
        }
        area(factboxes)
        {
            part(; 25006386)
            {
                SubPageLink = Service Order No.=FIELD(Service Order No.);
            }
            part(; 25006387)
            {
                SubPageLink = Service Order No.=FIELD(Service Order No.);
                    SubPageView = WHERE(Reversed=CONST(No));
            }
        }
    }

    actions
    {
        area(processing)
        {
            group()
            {
                action("Generate WIP")
                {
                    Caption = 'Generate WIP Worksheet Lines';

                    trigger OnAction()
                    var
                        WIPCalculation: Report "25006316";
                    begin
                        WIPCalculation.RUNMODAL;
                    end;
                }
                action("Recalculate WIP Amounts")
                {
                    Caption = 'Recalculate WIP Amounts';

                    trigger OnAction()
                    var
                        WIPRecalculation: Report "25006318";
                        WIPServiceOrderHeader: Record "25006192";
                    begin
                        WIPServiceOrderHeader.RESET;
                        IF Rec.GETFILTERS <> '' THEN
                            WIPServiceOrderHeader.COPYFILTERS(Rec)
                        ELSE
                            WIPServiceOrderHeader.SETRANGE("Service Order No.", Rec."Service Order No.");
                        WIPRecalculation.SETTABLEVIEW(WIPServiceOrderHeader);
                        WIPRecalculation.RUNMODAL;
                    end;
                }
                action("Post WIP")
                {
                    Caption = 'Post WIP';

                    trigger OnAction()
                    var
                        WIPPost: Report "25006317";
                        WIPServiceOrderHeader: Record "25006192";
                    begin
                        WIPServiceOrderHeader.RESET;
                        IF Rec.GETFILTERS <> '' THEN
                            WIPServiceOrderHeader.COPYFILTERS(Rec)
                        ELSE
                            WIPServiceOrderHeader.SETRANGE("Service Order No.", Rec."Service Order No.");
                        WIPPost.SETTABLEVIEW(WIPServiceOrderHeader);
                        WIPPost.RUNMODAL;
                    end;
                }
            }
        }
        area(navigation)
        {
            group()
            {
                action("Show Actual WIP Entries")
                {
                    Caption = 'Show Actual WIP Entries';
                    RunObject = Page 25006385;
                    RunPageLink = Service Order No.=FIELD(Service Order No.);
                    RunPageView = WHERE(Reversed=CONST(No));
                }
                action("Show Actual WIP G/L Entries")
                {
                    Caption = 'Show Actual WIP G/L Entries';

                    trigger OnAction()
                    var
                        WIPTotal: Record "25006196";
                        GLEntries: Record "17";
                        GLEntriesPage: Page "20";
                                           SourceCodeSetup: Record "242";
                    begin
                        SourceCodeSetup.GET;
                        WIPTotal.RESET;
                        WIPTotal.SETRANGE(Reversed, FALSE);
                        WIPTotal.SETRANGE("Service Order No.",Rec."Service Order No.");
                        IF WIPTotal.FINDFIRST THEN BEGIN
                          GLEntries.RESET;
                          GLEntries.SETRANGE("Document No.",WIPTotal."Document No.");
                          GLEntries.SETRANGE("Source Code",SourceCodeSetup."Service G/L WIP EDMS");
                          GLEntriesPage.SETTABLEVIEW(GLEntries);
                          GLEntriesPage.RUNMODAL;
                        END;
                    end;
                }
            }
        }
    }
}

