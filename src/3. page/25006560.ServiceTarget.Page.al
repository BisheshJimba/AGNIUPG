page 25006560 "Service Target"
{
    Caption = 'Service Target';
    PageType = List;
    SourceTable = Table25006198;

    layout
    {
        area(content)
        {
            group()
            {
                Visible = false;
                field(TotalAmount; TotalAmount)
                {
                    Caption = 'Total Amount';
                    Editable = false;
                    Enabled = false;
                }
                field(TotalQuantity; TotalQuantity)
                {
                    Caption = 'Total Quantity';
                    Editable = false;
                    Enabled = false;
                }
            }
            repeater(Group)
            {
                field(Location; Location)
                {
                }
                field("Service Advisor"; "Service Advisor")
                {
                }
                field(Resource; Resource)
                {
                }
                field(Date; Date)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field(Amount; Amount)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SetTarget)
            {
                Caption = 'Set Target';
                Image = Planning;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CLEAR(TargetSettingsPage);
                    TargetSettingsPage.RUNMODAL;
                end;
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        TotalAmount: Decimal;
        TotalQuantity: Decimal;
        TargetSettingsPage: Page "25006564";
}

