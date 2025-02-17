page 50028 "Bin Content (App)"
{
    Caption = 'Bin Content (App)';
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = Table7302;
    SourceTableView = WHERE(Quantity (Base)=FILTER(>0));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Location Code";"Location Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the location code of the bin.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the bin code.';
                }
                field("Item No.";"Item No.")
                {
                    ToolTip = 'Specifies the number of the item that will be stored in the bin.';
                }
                field("Item Description";"Item Description")
                {
                }
                field(Quantity;"Quantity (Base)")
                {
                    Caption = 'Quantity';
                    ToolTip = 'Specifies how many units of the item, in the base unit of measure, are stored in the bin.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Mobile App Admin" THEN BEGIN
          SETRANGE("Location Code",UserSetup."Default Location");
        END;
    end;

    var
        UserSetup: Record "91";
}

