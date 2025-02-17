page 25006010 "Process Checklist List"
{
    Caption = 'Inventory Checklist List';
    CardPageID = "Process Checklist";
    PageType = List;
    SourceTable = Table25006025;

    layout
    {
        area(content)
        {
            repeater()
            {
                Editable = false;
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Process Date"; "Process Date")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
                }
                field(VIN; VIN)
                {
                }
                field("Source ID"; "Source ID")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Checklist)
            {
                Caption = 'Checklist';
                action(Card)
                {
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006034;
                    RunPageLink = No.=FIELD(No.);
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }
}

