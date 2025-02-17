page 25006014 "Make List"
{
    Caption = 'Make List';
    CardPageID = "Make Card";
    DataCaptionFields = "Code";
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = Table25006000;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Make)
            {
                Caption = 'Make';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = Table ID=CONST(25006000),
                                  No.=FIELD(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action(Setup)
                {
                    Caption = 'Setup';
                    Image = Setup;
                    RunObject = Page 25006012;
                                    RunPageLink = Make Code=FIELD(Code);
                }
                action("Own Options")
                {
                    Caption = 'Own Options';
                    Image = CheckList;
                    RunObject = Page 25006499;
                                    RunPageLink = Make Code=FIELD(Code);
                }
                action(Models)
                {
                    Caption = 'Models';
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006016;
                                    RunPageLink = Make Code=FIELD(Code);
                }
                action("Model Versions")
                {
                    Caption = 'Model Versions';
                    Image = ListPage;
                    RunObject = Page 25006054;
                                    RunPageLink = Item Type=CONST(Model Version),
                                  Make Code=FIELD(Code);
                    RunPageView = SORTING(Item Type,Make Code,Model Code);
                }
            }
        }
    }
}

