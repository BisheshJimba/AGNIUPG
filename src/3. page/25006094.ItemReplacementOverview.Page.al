page 25006094 "Item Replacement Overview"
{
    // 20.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Changed Property - PopulateAllFields to "Yes"

    Caption = 'Item Replacement Overview';
    Editable = false;
    PageType = List;
    SourceTable = Table25006004;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Text Field 1"; "Text Field 1")
                {
                    Caption = 'Type';
                }
                field("Code Field 1"; "Code Field 1")
                {
                    Caption = 'No';
                }
                field("Code Field 2"; "Code Field 2")
                {
                    Caption = 'Variant Code';
                    Visible = false;
                }
                field("Text Field 2"; "Text Field 2")
                {
                    Caption = 'Replacement Type';
                }
                field("Code Field 3"; "Code Field 3")
                {
                    Caption = 'Replacement No.';
                }
                field("Code Field 4"; "Code Field 4")
                {
                    Caption = 'Replacement Variant Code';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}

