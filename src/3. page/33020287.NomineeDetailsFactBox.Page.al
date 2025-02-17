page 33020287 "Nominee Details FactBox"
{
    Caption = 'Nominee Details';
    PageType = CardPart;
    SourceTable = Table18;

    layout
    {
        area(content)
        {
            field("No."; "No.")
            {
                Caption = 'Nominee No.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field("Balance (LCY)"; "Balance (LCY)")
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Actions")
            {
                Caption = 'Actions';
                Image = "Action";
                action("Ship-to Address")
                {
                    Caption = 'Ship-to Address';
                    RunObject = Page 301;
                    RunPageLink = Customer No.=FIELD(No.);
                }
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page 124;
                                    RunPageLink = Table Name=CONST(Customer),
                                  No.=FIELD(No.);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
    end;

    var
        StyleTxt: Text;

    [Scope('Internal')]
    procedure ShowDetails()
    begin
        PAGE.RUN(PAGE::"Customer Card",Rec);
    end;
}

