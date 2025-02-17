page 25006858 "Lost Sales Entries"
{
    Caption = 'Lost Sales Entries';
    PageType = List;
    SourceTable = Table25006747;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Date; Date)
                {
                    Editable = false;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;
                }
                field("Item Category Code"; "Item Category Code")
                {
                    Editable = false;
                }
                field("Product Group Code"; "Product Group Code")
                {
                    Editable = false;
                }
                field("Product Subgroup Code"; "Product Subgroup Code")
                {
                    Editable = false;
                }
                field("Customer No."; "Customer No.")
                {
                    Editable = false;
                }
                field("Customer Name"; "Customer Name")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Description 2"; "Description 2")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Reason Code"; "Reason Code")
                {
                    Editable = false;
                }
                field("Reason Description"; "Reason Description")
                {
                    Visible = false;
                }
                field("Reason Description 2"; "Reason Description 2")
                {
                    Visible = false;
                }
                field(Priority; Priority)
                {
                    Editable = false;
                }
                field(Automatic; Automatic)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Entry No."; "Entry No.")
                {
                    Editable = false;
                }
                field("Closing Remarks"; "Closing Remarks")
                {
                }
                field(Close; Close)
                {
                    Editable = false;
                }
                field(Advance; Advance)
                {
                    Editable = false;
                }
                field("Assigned User Id"; "Assigned User Id")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Quantity; Quantity)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Closing)
            {
                action("Close Entry")
                {
                    Image = Close;

                    trigger OnAction()
                    begin

                        IF Rec."Closing Remarks" <> '' THEN
                            Rec.Close := TRUE
                        ELSE
                            ERROR('Please fill Closing Remarks field');
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SETFILTER(Close, '%1', FALSE);
        UserSetup.GET(USERID);
        SETFILTER("Location Code", UserSetup."Default Location");
    end;

    var
        CompInfo: Record "79";
        Hide: Boolean;
        UserSetup: Record "91";
}

