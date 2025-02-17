page 25006164 "Service Package Version-Select"
{
    Caption = 'Service Package Versions-Select';
    Editable = false;
    PageType = List;
    SourceTable = Table25006135;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Package No."; "Package No.")
                {
                }
                field("Package Description"; "Package Description")
                {
                }
                field("Version No."; "Version No.")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Prod. Year From"; "Prod. Year From")
                {
                }
                field("Prod. Year To"; "Prod. Year To")
                {
                }
                field("VIN From"; "VIN From")
                {
                }
                field("VIN To"; "VIN To")
                {
                }
                field("Kilometrage To"; "Kilometrage To")
                {
                    Visible = false;
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                    Visible = false;
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
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
            action(Card)
            {
                Caption = 'Card';
                Image = Card;
                Promoted = true;
                RunObject = Page 25006160;
                RunPageLink = No.=FIELD(Package No.);
                ShortCutKey = 'Shift+F5';
            }
            action("<Action1101907018>")
            {
                Caption = 'Version Lines';
                Image = Version;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 25006163;
                                RunPageLink = Package No.=FIELD(Package No.),
                              Version No.=FIELD(Version No.);
            }
        }
    }

    var
        SelectionRecordSet: Record "25006135";

    [Scope('Internal')]
    procedure GetSelectedRecordSet(var RecordSet: Record "25006135"): Boolean
    begin
        RecordSet := SelectionRecordSet;
        EXIT(SelectionRecordSet.MARKEDONLY);
    end;
}

