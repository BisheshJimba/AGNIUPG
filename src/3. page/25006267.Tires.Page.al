page 25006267 Tires
{
    Caption = 'Tires';
    CardPageID = "Tire Card";
    PageType = List;
    SourceTable = Table25006180;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Variable Field Run 1"; "Variable Field Run 1")
                {
                }
                field(Available; Available)
                {
                }
                field("Current Vehicle Serial No."; "Current Vehicle Serial No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1101904010>")
            {
                Caption = '&Entries';
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 25006269;
                RunPageLink = Tire Code=FIELD(Code);
                ShortCutKey = 'Ctrl+F7';
            }
            action("Update Item Tracking")
            {

                trigger OnAction()
                var
                    Item: Record "27";
                    Tire: Record "25006180";
                begin
                    Tire.RESET;
                    IF Tire.FINDSET THEN REPEAT
                      Item.RESET;
                      Item.SETRANGE("No.",Tire.Code);
                      IF Item.FINDFIRST THEN BEGIN
                        Item."Item Tracking Code" := '';
                        Item.MODIFY(TRUE);
                        Tire.DELETE;
                      END;
                    UNTIL Tire.NEXT = 0;
                end;
            }
        }
    }
}

