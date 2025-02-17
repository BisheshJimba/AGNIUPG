page 25006002 "Variable Fields"
{
    Caption = 'Variable Fields';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006002;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field(Caption; Caption)
                {
                }
                field("Make Dependent Lookup"; "Make Dependent Lookup")
                {
                }
                field("Variable Field Group Code"; "Variable Field Group Code")
                {
                }
                field("Use In Filtering"; "Use In Filtering")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Variable Field")
            {
                Caption = 'Variable Field';
                action(Options)
                {
                    Caption = 'Options';
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006007;
                    RunPageLink = Variable Field Code=FIELD(Code);
                }
                action(Translations)
                {
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page 25006003;
                                    RunPageLink = Variable Field Code=FIELD(Code);
                }
            }
        }
    }
}

