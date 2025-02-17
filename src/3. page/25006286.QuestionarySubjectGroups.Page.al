page 25006286 "Questionary Subject Groups"
{
    Caption = 'Questionary Subject Groups';
    PageType = List;
    SourceTable = Table25006208;

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
            action("Linked Questionary Templates")
            {
                Caption = 'Linked Questionary Templates';
                Image = LinkAccount;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 25006020;
                RunPageLink = Line No.=FIELD(Code);
            }
            action(Questions)
            {
                Caption = 'Questions';
                Image = QuestionaireSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 25006287;
                                RunPageLink = Questionary Subject Group Code=FIELD(Code);
            }
        }
    }
}

