page 25006055 "Contact Vehicles"
{
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added fields

    Caption = 'Contact Vehicles';
    DataCaptionFields = "Vehicle Serial No.";
    DelayedInsert = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Vehicles';
    SourceTable = Table25006013;
    SourceTableView = SORTING(Contact No.);

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Relationship Code"; "Relationship Code")
                {
                }
                field("Contact No."; "Contact No.")
                {
                    Visible = false;
                }
                field(VIN; VIN)
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(VehicleCard)
            {
                Caption = 'Vehicle Card';
                Image = Card;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    VehCard: Page "25006032";
                    Vehicle: Record "25006005";
                begin
                    Vehicle.GET("Vehicle Serial No.");
                    VehCard.SETRECORD(Vehicle);
                    VehCard.RUN;
                end;
            }
        }
    }
}

