page 25006276 "Vehicle Axles"
{
    Caption = 'Vehicle Axles';
    PageType = List;
    SourceTable = Table25006178;

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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1101904005>")
            {
                Caption = 'Axle';
                action("Tire &Position")
                {
                    Caption = 'Tire &Position';
                    Image = Position;
                    RunObject = Page 25006277;
                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                  Axle Code=FIELD(Code);
                }
                action("Tire &Entries")
                {
                    Caption = 'Tire &Entries';
                    Image = LedgerEntries;
                    RunObject = Page 25006269;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                  Vehicle Axle Code=FIELD(Code),
                                  Open=CONST(Yes);
                }
            }
            group("&Function")
            {
                Caption = '&Function';
                action("<Action1101904009>")
                {
                    Caption = 'Copy From Template';
                    Image = Template;

                    trigger OnAction()
                    begin
                        TireManagement.ShowCreateAxleFromTmpl(Rec);
                    end;
                }
            }
        }
    }

    var
        TireManagement: Codeunit "25006125";
}

