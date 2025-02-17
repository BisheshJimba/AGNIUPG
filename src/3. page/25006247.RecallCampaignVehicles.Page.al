page 25006247 "Recall Campaign Vehicles"
{
    Caption = 'Recall Campaign Vehicles';
    DataCaptionFields = "Campaign No.", VIN;
    DelayedInsert = true;
    PageType = Document;
    SourceTable = Table25006172;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Campaign No."; "Campaign No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field(Serviced; Serviced)
                {

                    trigger OnValidate()
                    begin
                        IF Serviced THEN BEGIN
                            SelectedRecallNo := "Campaign No.";
                            CurrPage.CLOSE;
                        END;
                    end;
                }
                field(Exists; Exists)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = 'Line';
                action(Campaign)
                {
                    Caption = 'Campaign';
                    Image = Campaign;
                    Promoted = true;
                    RunObject = Page 25006245;
                    RunPageLink = No.=FIELD(Campaign No.);
                }
                action(Vehicle)
                {
                    Caption = 'Vehicle';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Vehicle: Record "25006005";
                    begin
                        Vehicle.SETCURRENTKEY(VIN);
                        Vehicle.SETRANGE(VIN, VIN);
                        PAGE.RUNMODAL(PAGE::"Vehicle Card", Vehicle);
                    end;
                }
            }
        }
    }

    var
        SelectedRecallNo: Code[20];

    [Scope('Internal')]
    procedure GetSelectedRecallNo(): Code[20]
    begin
        EXIT(SelectedRecallNo);
    end;
}

