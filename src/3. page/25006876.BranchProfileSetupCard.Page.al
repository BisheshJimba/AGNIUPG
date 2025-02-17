page 25006876 "Branch Profile Setup Card"
{
    Caption = 'User Profile Setup';
    PageType = Card;
    SourceTable = Table25006876;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Branch Code"; "Branch Code")
                {
                }
                field("Profile ID"; "Profile ID")
                {
                }
                field(Description; Description)
                {
                }
                field("Make Code Filter"; "Make Code Filter")
                {
                }
                field("Default Deal Type Code"; "Default Deal Type Code")
                {
                }
                field("Default Make Code"; "Default Make Code")
                {
                }
                field("Default Location Code"; "Default Location Code")
                {
                }
                field("Default Location Filter"; "Default Location Filter")
                {
                }
                field("Default Vendor No."; "Default Vendor No.")
                {
                }
                field("Default Payment Method"; "Default Payment Method")
                {
                }
                field("Default Shipping Agent Code"; "Default Shipping Agent Code")
                {
                }
                field("Default Vehicle Status"; "Default Vehicle Status")
                {
                }
                field("Default Vehicle Purch. Status"; "Default Vehicle Purch. Status")
                {
                }
                field("Default Vehicle Sales Status"; "Default Vehicle Sales Status")
                {
                }
            }
            group("Spare Parts")
            {
                Caption = 'Spare Parts';
                field("Def. Spare Part Location Code"; "Def. Spare Part Location Code")
                {
                }
                field("Sales Line Markup Check"; "Sales Line Markup Check")
                {
                }
                field("Sales Line Min Markup %"; "Sales Line Min Markup %")
                {
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field("Def. Service Location Code"; "Def. Service Location Code")
                {
                }
                field("Spec. Service Setup"; "Spec. Service Setup")
                {
                }
                field("Spec. Branch Code"; "Spec. Branch Code")
                {
                }
                field("Spec. Servic Branch Profile"; "Spec. Servic Branch Profile")
                {
                    Caption = 'Spec. Service Branch Profile';
                }
                field("Spec. Order Receiver"; "Spec. Order Receiver")
                {
                }
                field("Service Schedule View Code"; "Service Schedule View Code")
                {
                }
            }
            group("Vehicle Sales")
            {
                Caption = 'Vehicle Sales';
                field("Don't Use Vehicle Assembly"; "Don't Use Vehicle Assembly")
                {
                }
                field("Show Vehicle Count"; "Show Vehicle Count")
                {
                }
                field("Vehicle Sales Disc. Check"; "Vehicle Sales Disc. Check")
                {
                }
                field("Vehicle Max Sales Disc.%"; "Vehicle Max Sales Disc.%")
                {
                }
            }
        }
    }

    actions
    {
    }
}

