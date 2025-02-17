page 25006015 "Model Card"
{
    Caption = 'Model Card';
    DataCaptionFields = "Make Code", "Commercial Name";
    PageType = Card;
    SourceTable = Table25006001;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Make Code"; "Make Code")
                {
                }
                field(Code; Code)
                {
                }
                field("Commercial Name"; "Commercial Name")
                {
                }
                field(Segment; Segment)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Model)
            {
                Caption = 'Model';
                action("Own Options")
                {
                    Caption = 'Own Options';
                    Image = CheckList;
                    RunObject = Page 25006499;
                    RunPageLink = Make Code=FIELD(Make Code),
                                  Model Code=FIELD(Code);
                }
                action("Model Versions")
                {
                    Caption = 'Model Versions';
                    Image = Versions;
                    RunObject = Page 25006054;
                                    RunPageLink = Item Type=CONST(Model Version),
                                  Make Code=FIELD(Make Code),
                                  Model Code=FIELD(Code);
                    RunPageView = SORTING(Item Type,Make Code,Model Code);
                }
                action("Terms and Conditions")
                {
                    Caption = 'Terms and Conditions';
                    RunObject = Page 33019917;
                                    RunPageLink = Model Code=FIELD(Code);

                    trigger OnAction()
                    begin
                         //message('err');
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SETRANGE("Make Code");
        SETRANGE(Code);
    end;
}

