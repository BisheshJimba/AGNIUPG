page 33020105 "Membership Form"
{
    Editable = true;
    PageType = Card;
    SourceTable = Table33019864;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Membership Card No."; "Membership Card No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Joined Date"; "Joined Date")
                {
                }
                field("Expiry Date"; "Expiry Date")
                {
                }
                field("Scheme Code"; "Scheme Code")
                {
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                }
                field(Status; Status)
                {
                }
                field("Contact No."; "Contact No.")
                {
                    Editable = false;
                }
                field("Insurance Amount"; "Insurance Amount")
                {
                    Visible = FieldVisible;
                }
                field("Free Recharge Coupon"; "Free Recharge Coupon")
                {
                    Visible = FieldVisible;
                }
                field("Recharge Amount"; "Recharge Amount")
                {
                    Visible = FieldVisible;
                }
                field("Driver Name"; "Driver Name")
                {
                    Visible = FieldVisible;
                }
            }
            part(; 33020110)
            {
                SubPageLink = Membership Card No.=FIELD(Membership Card No.);
            }
            part(; 33020113)
            {
                SubPageLink = Membership Card No.=FIELD(Membership Card No.);
            }
            part("Family Details"; 33020114)
            {
                Caption = 'Family Details';
                SubPageLink = Membership No.=FIELD(Membership Card No.);
                    Visible = FieldVisible;
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
    }

    trigger OnAfterGetRecord()
    begin
        IF "Free Recharge Coupon" THEN
            AmountEditable := TRUE
        ELSE
            AmountEditable := FALSE;

        IF CompanyInfo."Scheme Related Fields" THEN
            FieldVisible := TRUE
        ELSE
            FieldVisible := FALSE;
    end;

    trigger OnInit()
    begin
        CompanyInfo.GET;
    end;

    trigger OnOpenPage()
    begin
        IF CompanyInfo."Scheme Related Fields" THEN
            FieldVisible := TRUE
        ELSE
            FieldVisible := FALSE;
    end;

    var
        ModelVersionList: Page "25006054";
        [InDataSet]
        AmountEditable: Boolean;
        CompanyInfo: Record "79";
        [InDataSet]
        FieldVisible: Boolean;
}

