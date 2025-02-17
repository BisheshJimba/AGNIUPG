page 25006016 "Model List"
{
    Caption = 'Model List';
    CardPageID = "Model Card";
    DataCaptionFields = "Make Code", "Code";
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = Table25006001;
    SourceTableView = SORTING(View Sequence);

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
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
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006499;
                    RunPageLink = Make Code=FIELD(Make Code),
                                  Model Code=FIELD(Code);
                }
                action("Model Versions")
                {
                    Caption = 'Model Versions';
                    Image = Versions;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006054;
                                    RunPageLink = Item Type=CONST(Model Version),
                                  Make Code=FIELD(Make Code),
                                  Model Code=FIELD(Code);
                    RunPageView = SORTING(Item Type,Make Code,Model Code);
                }
                action("<Action1102159007>")
                {
                    Caption = 'Terms and Conditions';
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;
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

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;
}

